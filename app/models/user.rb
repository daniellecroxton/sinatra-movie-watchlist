class User < ActiveRecord::Base
  has_secure_password
  has_many :movies

  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 7 }
end
