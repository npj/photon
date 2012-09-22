class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  THUMBS = {
    :normal => "150x150>"
  }

  field :img_uid
  field :img_name
  field :code

  image_accessor :img

  embedded_in :album

  def full_url
    self.img.thumb("600x600>", :png).process(:auto_orient).url
  end

  def thumb_url(size = :normal)
    self.img.thumb(THUMBS[size], :png).process(:auto_orient).url
  end
end
