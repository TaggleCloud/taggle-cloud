class Abstract < ActiveRecord::Base
  attr_accessible :body, :user_id

  belongs_to :user
  belongs_to :conference
  has_many :tags
end
