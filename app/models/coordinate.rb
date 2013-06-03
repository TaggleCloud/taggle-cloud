class Coordinate < ActiveRecord::Base
  belongs_to :conference
  belongs_to :user
  attr_accessible :conference_id, :user_id
  
  validates_presence_of :conference_id
  validates_presence_of :user_id
end
