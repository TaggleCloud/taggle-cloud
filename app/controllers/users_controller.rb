class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    redirect_to profile_path if @user = current_user
  end

  def edit
    @user = current_user
    @interests_conf = Conference.find_by_name_and_location("User testing", "Here")
    @attendance = Attendance.find_or_create_by_conference_id_and_user_id(@interests_conf.id, @user.id)
    @abstract = Abstract.find_or_create_by_attendance_id(@attendance.id)
  end

  def dashboard
    @conferences = current_user.get_conferences
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update
    puts params
    @user = current_user
    @interests_conf = Conference.find_by_name_and_location("User testing", "Here")
    @attendance = Attendance.find_or_create_by_conference_id_and_user_id(@interests_conf.id, @user.id)
    @abstract = Abstract.find_or_create_by_attendance_id(@attendance.id)
    Abstract.update(@abstract.id, :body => params["user"]["abstract"]["body"])
    Connection.build_conf_connections(@interests_conf)
    params["user"].delete("abstract")
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end
end
