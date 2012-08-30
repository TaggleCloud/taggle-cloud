class Attendance < ActiveRecord::Base
  attr_accessible :conference_id, :registered_email, :user_id

  belongs_to :conference
  belongs_to :user
end
