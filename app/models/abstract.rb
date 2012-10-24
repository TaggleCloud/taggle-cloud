class Abstract < ActiveRecord::Base
  after_commit :tagbuilder
  attr_accessible :body, :user_id, :attendance_id

  belongs_to :user
  belongs_to :attendance
  has_many :abstract_tags
  
  private

  def tagbuilder
    TagsetBuilder.perform_async(:id)
    attendance.make_connections
  end
end