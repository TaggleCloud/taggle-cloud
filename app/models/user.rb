require 'pp'

class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid

  has_many :abstracts
  has_many :attendances
  has_many :emails

  def self.create_with_omniauth(auth)
    user = User.new
    pp auth
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.name = auth["info"]["name"]
    user.image = auth["info"]["image"] if auth["info"]["image"]
    extra = auth["extra"] if auth["extra"]
    raw_info = extra["raw_info"] if extra["raw_info"]
    if auth["provider"] == "facebook"
      work = raw_info["work"].first if raw_info["work"] && raw_info["work"].first
      employer = work["employer"]["name"] if work["employer"]
      position = work["position"]["name"] if work["position"]

      user.location = auth["info"]["location"] if auth["info"]["location"]
      user.occupation = position + " at " + employer
    elsif auth["provider"] == "linkedin"
      location = raw_info["location"] if raw_info["location"]
      user.occupation = auth["info"]["headline"] if auth["info"]["headline"]
      user.location = location["name"]
      user.location = user.location + ", " + location["country"]["code"] if location["country"]["code"]
    end
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

  def get_users_conferences
    return Conference.first
    #conferences = Array.new
    #self.attendances.each do |attendance|
    #  conferences << attendance.conferences
    #end
    #return conferences
  end

end
