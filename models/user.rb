require 'digest'

class User
  include Mongoid::Document
  field :email
  field :username
  field :password

  validates :email,    presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  class << self
    def authenticate(username, password)
      where(username: username, password: digest(password)).first
    end

    def digest(pwd)
      Digest::SHA2.base64digest(pwd)
    end
  end

  def password=(pwd)
    self[:password] = self.class.digest(pwd)
  end
end
