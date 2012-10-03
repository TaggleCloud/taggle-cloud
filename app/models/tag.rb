class Tag < ActiveRecord::Base
  attr_accessible :value
  
  has_many :abstract_tags
end
