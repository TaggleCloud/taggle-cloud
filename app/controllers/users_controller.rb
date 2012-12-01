class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
    @conferences = @user.get_conferences
  end

  def edit
    @user = User.find(params[:id])
    @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
    #@user.emails.build
    unless @user.is_admin || @user == current_user
      flash[:notice] = "You have no right to edit this user"
      redirect_to user_path(@user)
    end
  end

  def dashboard
    @conferences = current_user.get_conferences
    @bio = Abstract.where(:user_id => current_user.id, :is_bio => true).first
    @like_count = Like.where("user_id = ?", current_user.id).count
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update
    @user = current_user
    @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
    Abstract.update(@bio.id, :body => params["user"]["abstract"]["body"])
    params["user"].delete("abstract")
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to root_path, notice: 'Profile has been successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end
end
