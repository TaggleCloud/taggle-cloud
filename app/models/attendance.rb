class Attendance < ActiveRecord::Base
  attr_accessible :conference_id, :registered_email, :user_id, :first_name, :last_name, :organization

  belongs_to :conference
  belongs_to :user
  belongs_to :connection
  has_many :connections, :dependent => :destroy, :class_name => "Connection", :foreign_key => "attendance1_id"
  has_many :abstracts
  
  accepts_nested_attributes_for :abstracts

  def name
    return first_name.to_s + " " + last_name.to_s
  end

  def make_connections
    ConnectionBuilder.perform_async(:conference_id, :id)
  end

  def get_connection_strength(other_attendance)
    return Connection.get_connection(:id, other_attendance.id).strength
  end

end
