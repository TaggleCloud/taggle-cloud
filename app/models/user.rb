class User < ActiveRecord::Base
  after_create :create_keywords
  attr_accessible :first_name, :last_name, :image, :location, :occupation, :abstracts_attributes, :emails_attributes, :show_email, :is_admin, :bio

  has_many :abstracts
  has_many :attendances
  has_many :authentications
  has_many :emails
  has_many :user_interests
  has_many :interests, :through => :user_interests
  has_many :coordinates
  has_many :likes
  has_many :requests

  accepts_nested_attributes_for :abstracts
  accepts_nested_attributes_for :emails, :allow_destroy => true

  validates_presence_of :first_name
  validates_presence_of :last_name  

  def coordinate (conference)
    self.coordinates.each do |c|
      if c.conference_id == conference.id
        return true
      end
    end
    return false
  end

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

  # Bio no longer being used
  # def create_bio
  #   @bio = Abstract.create(:user_id => self.id)
  #   @bio.is_bio = true
  #   @bio.keywords = false
  #   @bio.save
  # end

  def create_keywords
    @keys = Abstract.create(:user_id => self.id)
    @keys.keywords = true
    @keys.is_bio = false
    @keys.save
  end
  
  def get_notifications
    notifications = Request.where('inviter = ? AND reply IS NOT NULL', self.id)
  end
  
  def get_accepted
    Request.where('inviter = ? AND user_id IS NOT NULL AND accepted = ?', self.id, true)
  end

  def get_invites
    Request.where('user_id = ? AND accepted = ?', self.id, false)
  end
  
  def get_requests
    Request.where('inviter = ? AND accepted = ?', self.id, false)
  end


  def attach_att(email_address)
    atts = Attendance.all
    atts.each do |a|
      if a.registered_email == email_address
        if a.user_id.nil?          
          a.user_id = self.id
          a.save
        end
      end
    end
  end
  
  def attach_request(email_address)
    requests = Request.where("email = ? AND invitee_registered = ? AND user_id is null", email_address, false).all
    requests.each do |r|
      r.user_id = self.id
      r.invitee_registered = true
      r.save
    end
  end
end
