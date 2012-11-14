class UsersController < ApplicationController

  def profile 
    @user = current_user
    @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
  end

  def show
    @user = User.find(params[:id])
    @interests_conf = Conference.find_by_name_and_location("User testing", "Here")
    @attendance = Attendance.find_or_create_by_conference_id_and_user_id(@interests_conf.id, @user.id)
    @abstract = Abstract.find_or_create_by_attendance_id(@attendance.id)
    redirect_to profile_path if @user == current_user
  end

  def edit
    @user = current_user
    @bio = Abstract.where(:is_bio => true, :user_id => @user.id).first
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
    # TODO: Need to update connections here somehow
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
