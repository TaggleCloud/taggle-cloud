class Request < ActiveRecord::Base
  attr_accessible :inviter, :user_id, :email, :invitee_registered, :body, :accepted, :reply, :email, :phone
  belongs_to :user
  
  validates_format_of :email, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format", :allow_blank => true
  validates_format_of :phone, :with => /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/, :message => "is not a valid format", :allow_blank => true
  validates_uniqueness_of :user_id, :scope => :inviter
end
