module Photon
  module Config
    module Dragonfly
      extend self

      def load(app)
        require 'dragonfly'

        images = ::Dragonfly[:images]

        images.define_macro_on_include(::Mongoid::Document, :image_accessor)

        images.datastore = ::Dragonfly::DataStorage::S3DataStore.new
        images.datastore.configure do |c|
          c.bucket_name       = app.s3_bucket
          c.access_key_id     = app.s3_access_key_id
          c.secret_access_key = app.s3_secret_access_key
          c.storage_headers   = { 'x-amz-acl' => 'private' }
        end
      end
    end
  end
end
