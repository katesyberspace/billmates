class Bill < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :comments
 end
