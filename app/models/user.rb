class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid

  has_many :abstracts
  has_many :attendances
  has_many :emails
  has_many :user_interests
  has_many :interests, :through => :user_interests
  
  accepts_nested_attributes_for :abstracts

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

  def get_conferences
    conferences = []
    self.attendances.each do |attendance|
     conferences << attendance.conference
    end
    return conferences
  end

end
