class Email < ActiveRecord::Base
  attr_accessible :mail_address, :user_id
  
  belongs_to :user
end
