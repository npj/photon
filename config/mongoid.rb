module Photon
  module Config
    module Mongoid
      extend self

      def config_file
        File.expand_path('../files/mongoid.yml.erb', __FILE__)
      end

      def load(app)
        require 'mongoid'
        ::Mongoid.load!(ERB.new(config_file).result)
      end
    end
  end
end
