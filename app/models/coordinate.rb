class Coordinate < ActiveRecord::Base
  belongs_to :conference
  belongs_to :user
  attr_accessible :conference_id, :user_id
end
