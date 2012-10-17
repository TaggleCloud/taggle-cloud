class Attendance < ActiveRecord::Base
  attr_accessible :conference_id, :registered_email, :user_id, :first_name, :last_name, :organization

  belongs_to :conference
  belongs_to :user
  belongs_to :connection
  has_many :connections, :dependent => :destroy, :class_name => "Connection", :foreign_key => "attendance1_id"
  has_many :abstracts

  def name
    return first_name.to_s + " " + last_name.to_s
  end

end
