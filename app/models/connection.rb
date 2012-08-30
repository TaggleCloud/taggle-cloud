class Connection < ActiveRecord::Base
  attr_accessible :conference_id, :user1_id, :user2_id

  belongs_to :conference
  belongs_to :user
  has_one :user
end
