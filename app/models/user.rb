class User < ActiveRecord::Base
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
 
  private
  
  def create_remember_token
    # Notes on self.variable vs @variable 
    # @variable won't work for an
    # active record attribute, since those aren't stored in individual
    # instance variables (AR stores a hash of all the database attributes in
    # one place). Uing self ensures that assignment sets the user's remember_token, 
    # and as a result it will be written to the database along with other attributes
    # when the user is saved. 
    self.remember_token = User.digest(User.new_remember_toekn)
  end
end
