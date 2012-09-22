class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  include Photon::Model::Code

  THUMBS = {
    :normal => "150x150>"
  }

  attr_accessible :img

  field :img_uid
  field :img_name

  image_accessor :img

  embedded_in :album

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
