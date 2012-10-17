class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  include Photon::Model::Code

  THUMBS = {
    :normal => "260x180>",
    :full   => "600x600>"
  }

  attr_accessible :img

  field :img_uid
  field :img_name

  image_accessor :img

  embedded_in :album
  embeds_many :thumbnails

  class << self
    def placeholder
      unless @placeholder
        @placeholder = Object.new
        class << @placeholder
          def thumb_url(size = :normal)
            "http://placehold.it/#{THUMBS[size].gsub(/\>\!/, "")}/073642/b58900&text=%20"
          end
        end
      end
      @placeholder
    end
  end

  def full_url
    thumb_url(:full)
  end

  def thumb_url(size = :normal)
    thumb! { self.img.process(:auto_orient).thumb(THUMBS[size], :png) }.url
  end

  protected

    def code_scope
      self.album.photos
    end

    def thumb!
      yield.tap do |job|
        unless self.thumbnails.find_by(job: job.serialize)
          self.thumbnails.create(job: job.serialize, stored: false)
        end
      end
    end
end
