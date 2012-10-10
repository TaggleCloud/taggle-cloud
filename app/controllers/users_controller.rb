class UsersController < ApplicationController

  def dashboard
    @user = current_user
    @conferences = @user.get_users_conferences
  end

  def profile
    @user = current_user
  end

end