class Request < ActiveRecord::Base
  attr_accessible :inviter, :user_id, :email, :invitee_registered, :body
  belongs_to :user
  
end
