class User < ActiveRecord::Base
  after_create :create_bio
  attr_accessible :first_name, :last_name, :image, :location, :occupation, :abstract_attributes

  has_many :abstracts
  has_many :attendances
  has_many :authentications
  has_many :emails
  has_many :user_interests
  has_many :interests, :through => :user_interests
 
  accepts_nested_attributes_for :abstracts

  def name
    return self.first_name.to_s + " " + self.last_name.to_s
  end

  def get_conferences
    conferences = []
    self.attendances.each do |attendance|
     conferences << attendance.conference
    end
    return conferences
  end

  def self.create_with_omniauth(auth)
    user = User.new
    authentication = Authentication.where(:uid => auth["uid"], :provider => auth["provider"])
    if authentication.size > 0
      return User.find(authentication.last.user_id)
    else
      email = auth["info"]["email"]
      eModel = Email.find_by_mail_address(email)

      if eModel
        aModel = Authentication.new
        aModel.uid = auth["uid"]
        aModel.provider = auth["provider"]
        aModel.user_id = eModel.user_id
        aModel.save
        return User.find(aModel.user_id)
      end

      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.image = auth["info"]["image"] if auth["info"]["image"]
      extra = auth["extra"] if auth["extra"]
      raw_info = extra["raw_info"] if extra["raw_info"]
      if auth["provider"] == "facebook"
        work = raw_info["work"].first if raw_info["work"] && raw_info["work"].first
        if work
          employer = work["employer"]["name"] if work["employer"]
          position = work["position"]["name"] if work["position"]
          user.occupation = position + " at " + employer
        end
        user.location = auth["info"]["location"] if auth["info"]["location"]
      elsif auth["provider"] == "linkedin"
        location = raw_info["location"] if raw_info["location"]
        user.occupation = auth["info"]["headline"] if auth["info"]["headline"]
        user.location = location["name"]
        user.location = user.location + ", " + location["country"]["code"] if location["country"]["code"]
      end
      user.save

      unless eModel
        eModel = Email.new
        eModel.mail_address = email
        eModel.user_id = user.id
        eModel.save
        aModel = Authentication.new
        aModel.uid = auth["uid"]
        aModel.provider = auth["provider"]
        aModel.user_id = eModel.user_id
        aModel.save
      end
      return user
    end
  end
  
  def create_bio
    bio = Abstract.create(:user_id => user.id, :is_bio => true)
  end

end
