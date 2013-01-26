module Photon
  module Config
    module Logging
      extend self

      def load(app)
        app.enable :logging
        app.use Rack::CommonLogger
      end
    end
  end
end
