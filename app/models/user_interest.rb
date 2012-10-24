class UserInterest < ActiveRecord::Base
  attr_accessible :interest_id, :user_id

  belongs_to :user
  belongs_to :interest
end
