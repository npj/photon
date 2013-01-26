class Comment
  include Photon::Model
  include Photon::Model::Code

  field :body
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :user, :commentable, presence: true

  protected

    def code_scope
      self.commentable.comments
    end
end
