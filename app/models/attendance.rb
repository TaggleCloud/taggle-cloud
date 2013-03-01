class Attendance < ActiveRecord::Base
  attr_accessible :conference_id, :registered_email, :user_id, :first_name, :last_name, :organization, :abstracts_attributes, :project_name, :bio

  belongs_to :conference
  belongs_to :user
  belongs_to :connection
  has_many :connections, :dependent => :destroy, :class_name => "Connection", :foreign_key => "attendance1_id"
  has_many :abstracts, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :preferences, :dependent => :destroy

  accepts_nested_attributes_for :abstracts

  def name
    return first_name.to_s + " " + last_name.to_s
  end

  # def make_connections
  #     ConnectionBuilder.perform_async(:conference_id, :id)
  #   end

  def get_connection_strength(other_attendance)
    return Connection.get_connection(self.id, other_attendance.id).first.strength if Connection.get_connection(self.id, other_attendance.id).first
  end

  def get_categories
	  @conf = Conference.find(:conference_id)
	  return @conf.preference_categories.parse(',')	  
  end
end
