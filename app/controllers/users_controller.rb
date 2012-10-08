class UsersController < ApplicationController

  def profile
    @user = User.find(params[current_user.id])
  end

end