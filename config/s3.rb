module Photon
  module Config
    module S3
      extend self

      def config_file
        File.expand_path("../files/s3.yml.erb", __FILE__)
      end

      def load(app)
        require 'aws/s3'

        config = YAML.load(ERB.new(File.read(config_file)).result)

        config[app.environment.to_s].tap do |s3|
          app.configure do
            app.set :s3_access_key_id,     s3['access_key_id']
            app.set :s3_secret_access_key, s3['secret_access_key']
            app.set :s3_bucket,            s3['bucket']
          end
        end

        AWS::S3::Base.establish_connection!({
              access_key_id: app.s3_access_key_id,
          secret_access_key: app.s3_secret_access_key
        })
      end
    end
  end
end
