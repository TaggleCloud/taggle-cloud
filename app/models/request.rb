class Request < ActiveRecord::Base
  attr_accessible :receiver, :user_id, :email, :invitee_registered, :body
  belongs_to :user
  
end
