class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]{2,3}\z/i
  validates :email, presence: true, length: {maximum: 254}, 
          format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password_confirmation, presence: true, length: {minimum: 6}
  before_save { self.email = email.downcase }
end
