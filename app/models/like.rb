class Like < ActiveRecord::Base
  attr_accessible :attendance_id, :user_id
  belongs_to :user
  belongs_to :attendance
  belongs_to :conference
  
end
