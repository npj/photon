module Photon
  module Config
    module Dragonfly
      extend self

      def config!
        images = ::Dragonfly[:images]

        images.define_macro_on_include(Mongoid::Document, :image_accessor)

        images.datastore = ::Dragonfly::DataStorage::S3DataStore.new
        images.datastore.configure do |c|
          c.bucket_name       = ENV['AWS_S3_BUCKET']
          c.access_key_id     = ENV['AWS_S3_ACCESS_KEY_ID']
          c.secret_access_key = ENV['AWS_S3_SECRET_ACCESS_KEY']
          c.storage_headers   = { 'x-amz-acl' => 'private' }
        end

        images.configure do |c|
          c.define_url do |app, job, options|
            j = job.serialize
            if thumb = Thumbnail.find_by_job(j, true)
              app.datastore.url_for(thumb.uid, expires: 10.seconds.from_now)
            else
              app.server.url_for(job)
            end
          end

          c.server.before_serve do |job, env|
            uid = job.store
            j   = job.serialize
            if thumb = Thumbnail.find_by_job(j, false)
              thumb.update_attributes(uid: uid, stored: true)
            end
          end
        end
      end
    end
  end
end

Photon::Config::Dragonfly.config!
