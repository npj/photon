class Album
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :code

  belongs_to :user
  embeds_many :photos

  def cover
    if photo = self.photos.where(cover: true).first
      photo.img
    end
  end

  # can take a photo or photo id
  def cover=(photo)

    id = (photo.respond_to?(:id) ? photo.id : photo)

    if p = self.photos.find_by(id: id)
      self.photos.where(cover: true).update_all(cover: false)
      p.cover = true
      p.save
      p.img
    end
  end
end
