# allows use of Rails-like dynamic forms,
# for example, a logout link which uses
# the DELETE method
module Photon
  class HttpMethods
    def initialize(app)
      @app = app
    end

    def call(env)
      r = Rack::Request.new(env)

      if %w{ POST PUT DELETE }.include?(r['_method'])
        env['REQUEST_METHOD'] = r['_method']
      end

      @app.call(env)
    end
  end
end

