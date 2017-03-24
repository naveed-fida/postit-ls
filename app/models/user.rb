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
  validates :phone, uniqueness: true, length: {minimum: 10, maximum: 10}

  def admin?
    role == 'admin'
  end

  def moderator?
    role == 'moderator'
  end

  def generate_pin!
    update_column(:pin, rand(10 ** 6))
  end

  def two_factor_auth?
    !phone.blank?
  end

  def obscured_phone
    obs = phone.strip
    obs[2..-3] = '*' * 6
    obs
  end

  def remove_pin!
    update_column(:pin, nil)
  end
end
