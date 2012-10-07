module Photon
  module Config
    module S3
      extend self

      def load!
        file   = File.join(File.dirname(__FILE__), "files", "s3.yml.erb")
        config = YAML.load(ERB.new(File.read(file)).result)
        env    = Sinatra::Base.environment.to_s

        AWS::S3::Base.establish_connection!({
              access_key_id: config[env]['access_key_id'],
          secret_access_key: config[env]['secret_access_key']
        })
      end
    end
  end
end

Photon::Config::S3.load!
