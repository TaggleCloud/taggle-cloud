class Tag < ActiveRecord::Base
  attr_accessible :abstract_tag_id, :value
  
  belongs_to :abstract_tag
end
