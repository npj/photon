require 'rack/cache'

module Photon
  module Cache
    extend self

    def registered(app)
      app.use Rack::Cache, {
          metastore: URI.encode("file:#{app.root}/../tmp/dragonfly/cache/meta"),
        entitystore: URI.encode("file:#{app.root}/../tmp/dragonfly/cache/body")
      }
    end
  end
end
