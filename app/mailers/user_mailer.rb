class UserMailer < ActionMailer::Base  
  default :from => "tagglecloud@gmail.com"  
  
  def request_email(user)
    @user = user
    mail(:to => user.registered_email, :subject => "Someone wants to meet you")  
  end  

  def conference_email(user, conference)
    if user.user_id.nil?
      @registered = false
    else 
      @registered = true
    end
    @conference = conference
    mail(:to => user.registered_email, :subject => "You are registered for #{conference.name}")  
  end  

end