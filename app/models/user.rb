class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid

  has_many :abstracts
  has_many :attendances
  has_many :emails

  def self.create_with_omniauth(auth)
    user = User.new
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.name = auth["info"]["name"]
    user.save

    email = auth["info"]["email"]
    eModel = Email.find_by_mail_address(email)

    if eModel
      eModel.user_id = user.id
      eModel.save
    else
      eModel = Email.new
      eModel.mail_address = email
      eModel.user_id = user.id
      eModel.save
    end
    
    return user
  end
end
