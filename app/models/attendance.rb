class Attendance < ActiveRecord::Base
  after_create :default_bio
  after_update :default_bio
  attr_accessible :conference_id, :registered_email, :user_id, :first_name, :last_name, :organization, :abstracts_attributes, :project_name, :bio

  belongs_to :conference
  belongs_to :user
  belongs_to :connection
  has_many :connections, :dependent => :destroy, :class_name => "Connection", :foreign_key => "attendance1_id"
  has_many :abstracts, :dependent => :destroy
  has_many :likes, :dependent => :destroy

  accepts_nested_attributes_for :abstracts

  def name
    return first_name.to_s + " " + last_name.to_s
  end
  
  def get_bio
	  return bio.to_s.scan(/#\S+/)
  end

  def default_bio
    if self.bio == nil 
      self.bio = Abstract.where(:user_id => self.user_id, :is_bio => true).first.body
      self.save
    end
  end

  # def make_connections
  #     ConnectionBuilder.perform_async(:conference_id, :id)
  #   end

  def get_connection_strength(other_attendance)
    return Connection.get_connection(self.id, other_attendance.id).first.strength if Connection.get_connection(self.id, other_attendance.id).first
  end

end
