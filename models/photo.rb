class Photo
  include Photon::Model
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
  has_many :comments, as: :commentable, dependent: :destroy

  class_methods do
    def placeholder
      @placeholder ||= Photon::Meta.new do
        def thumb_url(size = :normal)
          "http://placehold.it/#{THUMBS[size].gsub(/\>|\!/, "")}/073642/b58900&text=%20"
        end
      end
    end
  end

  def full_url
    thumb_url(:full)
  end

  def thumb_url(size = :normal)
    self.img.process(:auto_orient).thumb(THUMBS[size], :png).url
  end

  protected

    def code_scope
      self.album.photos
    end
end
