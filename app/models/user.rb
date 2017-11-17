class User < ActiveRecord::Base
  has_secure_password
  has_many :movies

  validates :email, presence: true, uniqueness: true
  validates :password, :presence: true, length: { minimum: 7 }
end
