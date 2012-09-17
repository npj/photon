module Photon
  module Auth

    def self.registered(app)
      create_admin_user
      configure_warden
      define_routes(app)
      add_middleware(app)
    end

    def self.define_routes(app)
      app.get '/auth/login/?' do
        slim :'auth/login', locals: { nav: false }
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

    def self.add_middleware(app)
      app.use Rack::Session::Cookie

      app.use Warden::Manager do |config|
        config.default_strategies :password
        config.failure_app = Sinatra.new do
          post '/unauthenticated/?' do
            redirect "/auth/login"
          end
        end
      end
    end

    def self.create_admin_user
      ENV.values_at('PHOTON_ADMIN_EMAIL', 'PHOTON_ADMIN_PASSWORD').tap do |(email, password)|
        if email && password
          unless User.authenticate(email, password)
            User.create(email: email, password: password)
          end
        end
      end
    end

    def self.configure_warden
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
          params["email"] || params["password"]
        end

        def authenticate!
          if u = User.authenticate(params["email"], params["password"])
            puts u.inspect
            success!(u)
          else
            fail!("Could not log in")
          end
        end
      end
    end
  end
end

