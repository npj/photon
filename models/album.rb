class Album
  include Photon::Model
  include Photon::Model::Code

  field :title
  field :code

  belongs_to :user
  embeds_many :photos, order: { created_at: :desc }
  has_many    :comments, as: :commentable, order: { created_at: :desc }, dependent: :destroy

  validates :user, presence: true

  default_scope order_by(created_at: :desc)

  class << self
    def create_with_defaults(params = { })
      self.new(params).tap do |album|
        album.title = "Untitled Album"
        album.save
      end
    end
  end

  def empty?
    self.photos.empty?
  end

  def cover
    self.photos.where(cover: true).first || self.photos.first || Photo.placeholder
  end

  # can take a photo or photo id
  def cover=(photo)

    id = (photo.respond_to?(:id) ? photo.id : photo)

    if p = self.photos.find_by(id: id)
      self.photos.where(cover: true).update_all(cover: false)
      p.cover = true
      p.save
      p
    end
  end

  protected

    def code_scope
      Album
    end
end
