# User model
class User < ActiveRecord::Base
  include Sluggable
  sluggable_column :username
  has_many :posts
  has_many :comments
  has_many :votes
  has_secure_password validations: false
  before_save :generate_slug

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: { minimum: 5 }

  def admin?
    role == 'admin'
  end

  def moderator?
    role == 'moderator'
  end
end
