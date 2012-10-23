class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    redirect_to profile_path if @user = current_user
  end

  def dashboard
    @user = current_user
    @conferences = @user.get_users_conferences
  end

  def profile
    @user = current_user
  end
end