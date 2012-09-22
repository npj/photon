module Photon
  module Processing
    class << self
      def registered(app)
        configure_dragonfly
        add_middleware(app)
      end

      private

        def configure_dragonfly
          Dragonfly[:images].tap do |dragonfly|
            dragonfly.configure_with(:imagemagick) do |config|
              config.url_format = '/media/:job'
            end
          end
        end

        def add_middleware(app)
          app.use Dragonfly::Middleware, :images
        end
    end
  end
end

