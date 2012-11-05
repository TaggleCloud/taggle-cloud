class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    #FIXME check auth here instead of in user
    user = User.create_with_omniauth(auth)
    session[:user_id] = user.id
    @conf = Conference.find_or_create_by_name_and_location("User testing", "Here")
    if(!Attendance.find_by_conference_id_and_user_id(@conf.id, user.id))
      @att = Attendance.create(:conference_id => @conf.id, :user_id => user.id, :first_name => user.first_name, :last_name => user.last_name)
      Abstract.create(:body => "", :user_id => user.id, :attendance_id => @att.id)
    end
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
