class Thumbnail
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid
  field :job
  field :stored, type: Boolean

  embedded_in :photo

  after_destroy :destroy_file

  class << self
    def find_by_job(j, stored)
      if album = Album.where('photos.thumbnails.job' => j, 'photos.thumbnails.stored' => stored).first
        album.photos.each do |photo|
          if thumb = photo.thumbnails.find_by(job: j, stored: stored)
            return thumb
          end
        end
      end

      return nil
    end
  end

  protected

    def destroy_file
      Dragonfly[:images].datastore.destroy(self.uid)
    end
end
