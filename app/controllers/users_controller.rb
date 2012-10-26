class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    redirect_to profile_path if @user = current_user
  end

  def dashboard
    @conferences = current_user.get_conferences
  end

  def profile
    @user = current_user
    @attendance = Attendance.new(:user_id => @user.id, :conference_id => Conference.find(:first, :conditions => ["name = :n", {:n => "User testing"}, "location = :l", {:l => "Here"}]))
    @abstract = Abstract.new(:attendance_id => @attendance.id, :body => params[:body])
    
    # respond_to do |format|
    #   if @abstract.save
    #     format.html { redirect_to @user, notice: 'Interest was successfully added.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: "profile" }
    #     format.json { render json: @abstract.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update
    @user = current_user
   
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        #format.html { render action: "edit" }
        #format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end
end
