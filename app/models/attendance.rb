class Attendance < ActiveRecord::Base
  attr_accessible :conference_id, :registered_email, :user_id, :first_name, :last_name, :organization

  after_create :make_connections

  belongs_to :conference
  belongs_to :user
  belongs_to :connection
  has_many :connections, :dependent => :destroy, :class_name => "Connection", :foreign_key => "attendance1_id"
  has_many :abstracts

  def name
    return first_name.to_s + " " + last_name.to_s
  end

  def make_connections
    ConnectionBuilder.perform_async(:conference_id, :id)
  end

end
