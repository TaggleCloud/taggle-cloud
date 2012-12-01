class Like < ActiveRecord::Base
  attr_accessible :attendance_id, :user_id
  belongs_to :conference
  belongs_to :user
  belongs_to :attendance
  
  validates_uniqueness_of :user_id, :scope => :attendance_id
  
end
