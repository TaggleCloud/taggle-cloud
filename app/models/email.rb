class Email < ActiveRecord::Base
  attr_accessible :mail_address, :user_id
  
  belongs_to :user
  
  validates_format_of :mail_address, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format"
  
end
