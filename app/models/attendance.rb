class Attendance < ActiveRecord::Base
  attr_accessible :conference_id, :registered_email, :user_id

  belongs_to :conference
  belongs_to :user
  belongs_to :connection
  has_one :connection
  has_many :abstracts

end
