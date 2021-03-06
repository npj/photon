require 'warden'

module Photon
  module Auth
    extend self

    REASON = {
      credentials: {
           code: 1,
        message: "Username or password incorrect."
      }
    }

    def registered(app)
      create_admin_user
      configure_warden
      define_routes(app)
      add_helpers(app)
      add_middleware(app)
    end

    def define_routes(app)
      app.get '/auth/login/?' do

        error = nil

        if params[:reason]
          if list = REASON.find { |_, hash| hash[:code] == params[:reason].to_i }
            error = list[1][:message]
          end
        end

        slim :'auth/login', locals: { nav: false, error: error }
      end

      app.post '/auth/login/?' do
        env['warden'].authenticate!
        redirect '/'
      end

      app.delete '/auth/logout/?' do
        env['warden'].logout
        redirect '/'
      end
    end

    def add_helpers(app)
      app.helpers do
        def current_user
          env['warden'].user
        end
      end
    end

    def add_middleware(app)
      app.use Rack::Session::Cookie

      app.use Warden::Manager do |config|
        config.default_strategies :password
        config.failure_app = Sinatra.new do
          post '/unauthenticated/?' do
            res = env['warden.options'][:reason]
            redirect "/auth/login#{res ? "?reason=#{res}" : ""}"
          end
        end
      end
    end

    def create_admin_user
      username, email, password = ENV.values_at(*%w{ PHOTON_ADMIN_USERNAME PHOTON_ADMIN_EMAIL PHOTON_ADMIN_PASSWORD })
      if username && email && password
        unless User.authenticate(username, password)
          User.create(email: email, username: username, password: password)
        end
      end
    end

    def configure_warden
      Warden::Manager.serialize_into_session { |user| user.id       }
      Warden::Manager.serialize_from_session { |id|   User.find(id) }

      Warden::Manager.before_failure do |env, opts|
        # Sinatra is very sensitive to the request method
        # since authentication could fail on any type of method, we need
        # to set it for the failure app so it is routed to the correct block
        env['REQUEST_METHOD'] = "POST"
      end

      Warden::Strategies.add(:password) do

        def valid?
          params["username"] || params["password"]
        end

        def authenticate!
          if u = User.authenticate(params["username"], params["password"])
            success!(u)
          else
            throw :warden, :reason => REASON[:credentials][:code]
          end
        end
      end
    end
  end
end

