class Tag < ActiveRecord::Base
  attr_accessible :abstract_id, :value
  
  belongs_to :abstract
end
