class User < ActiveRecord::Base
  has_secure_password
  has_many :bills
  has_many :usersxbills
 end