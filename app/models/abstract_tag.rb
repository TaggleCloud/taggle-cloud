class AbstractTag < ActiveRecord::Base
  attr_accessible :abstract_id, :tag_id
  
  belongs_to :abstract
  has_one :tag
end
