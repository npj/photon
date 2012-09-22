module Photon
  module Cache
    class << self
      def registered(app)
        app.use Rack::Cache, {
            metastore: URI.encode("file:#{app.settings.root}/../tmp/dragonfly/cache/meta"),
          entitystore: URI.encode("file:#{app.settings.root}/../tmp/dragonfly/cache/body")
        }
      end
    end
  end
end
