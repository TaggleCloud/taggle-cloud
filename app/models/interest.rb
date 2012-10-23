class Interest < ActiveRecord::Base
  attr_accessible :interest

  has_many :user_interests
  has_many :users, :through => :user_interests
end
