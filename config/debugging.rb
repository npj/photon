require 'debugger'

module Photon
  module Config
    module Debugging
      extend self

      class Middleware
        def initialize(app)
          @app = app
        end

        def call(env)
          debugger
          @app.call(env)
        end
      end

      def load(app)
        # Debugger.start_remote
        # app.use Middleware
      end
    end
  end
end
