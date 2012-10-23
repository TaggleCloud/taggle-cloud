class Tag < ActiveRecord::Base
  attr_accessible :value
  
  has_many :abstract_tags
  has_many :abstracts, :through => :abstract_tags
end
