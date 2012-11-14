class UsersController < ApplicationController

  def profile 
    @user = current_user
    @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
  end

  def show
    @user = User.find(params[:id])
    @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
    redirect_to profile_path if @user == current_user
  end

  def edit
    @user = current_user
    @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
  end

  def dashboard
    @conferences = current_user.get_conferences
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
        format.html { redirect_to profile_path, notice: 'Profile has been successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end
end
