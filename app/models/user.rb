class User < ActiveRecord::Base
  attr_accessible :nsid, :username, :fullname
  has_many :photos
end
