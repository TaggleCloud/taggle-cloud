class UsersController < ApplicationController

  def dashboard
    @user = current_user
    @conferences = @user.get_users_conferences
  end

  def profile
    @user = current_user
    @attendance = Attendance.new(:user_id => @user.id, :conference_id => nil)
    @abstract = Abstract.new(:attendance_id => @attendance.id, :body => params[:body]) # Running create_tags on nil before page loads, not on submit

    respond_to do |format|
      if @abstract.save
        format.html { redirect_to @user, notice: 'Interests successfully added.' }
        format.json { render json: @abstract, status: :created, location: @abstract }
      else
        format.html { render action: "new" }
        format.json { render json: @abstract.errors, status: :unprocessable_entity }
      end
    end
    
  end
end