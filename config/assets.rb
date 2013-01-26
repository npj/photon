module Photon
  module Config
    module Assets
      extend self

      def load(app)
        app.configure :staging, :development do
          app.helpers do
            def asset_path(path)
              "/#{path}"
            end
          end
        end

        app.configure :production do
          app.helpers do
            def asset_path(path)
              "https://s3.amazonaws.com/assets.photon/#{path}"
            end
          end
        end
      end
    end
  end
end
