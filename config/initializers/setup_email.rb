ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "tagglecloud.herokuapp.com",  
  :user_name            => "tagglecloud",  
  :password             => "taggleadmin",  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}