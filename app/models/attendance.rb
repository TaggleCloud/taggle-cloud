class Attendance < ActiveRecord::Base
  attr_accessible :conference_id, :registered_email, :user_id, :first_name, :last_name, :organization

  belongs_to :conference
  belongs_to :user
  belongs_to :connection
  has_one :connection, :dependent => :destroy
  has_many :abstracts

end
