class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationships",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  # Validation
  validates :name, presence: true, length: { maximum: 50 } 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  # Callbacks
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def feed
    # This is preliminary for now
    Micropost.where("user_id = ?", id)
  end
  
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end
 
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
 
  private
  
  def create_remember_token
    # Notes on self.variable vs @variable 
    # @variable won't work for an
    # active record attribute, since those aren't stored in individual
    # instance variables (AR stores a hash of all the database attributes in
    # one place). Uing self ensures that assignment sets the user's remember_token, 
    # and as a result it will be written to the database along with other attributes
    # when the user is saved. 
    self.remember_token = User.digest(User.new_remember_token)
  end
end
