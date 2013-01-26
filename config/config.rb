module Photon
  module Config
    extend self

    def load(app)

      %w{ s3 assets mongoid dragonfly debugging logging }.each do |sub|
        require File.expand_path("#{app.root}/../config/#{sub}")
      end

      app.configure :development do
        Debugging.load(app)
      end

      app.configure :development, :staging do
        Logging.load(app)
      end

      S3.load(app)
      Assets.load(app)
      Mongoid.load(app)
      Dragonfly.load(app)
    end
  end
end
