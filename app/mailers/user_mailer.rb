class UserMailer < ActionMailer::Base  
  default :from => "tagglecloud@gmail.com"  
  
  def request_email(user)
    mail(:to => user.registered_email, :subject => "Someone wants to meet you")  
  end  
end