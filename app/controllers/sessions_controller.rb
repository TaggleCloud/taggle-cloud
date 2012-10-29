class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    #FIXME check auth here instead of in user
    user = User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
