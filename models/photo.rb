class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  include Photon::Model::Code

  THUMBS = {
    :normal => "260x180>"
  }

  attr_accessible :img

  field :img_uid
  field :img_name

  image_accessor :img

  embedded_in :album

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
    self.img.thumb("600x600>", :png).process(:auto_orient).url
  end

  def thumb_url(size = :normal)
    self.img.thumb(THUMBS[size], :png).process(:auto_orient).url
  end

  protected

    def code_scope
      self.album.photos
    end
end
