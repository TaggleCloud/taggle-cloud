class RequestsController < ApplicationController
  
  def new
    @user = current_user
    @attendance = Attendance.find(params[:attendance_id])
    @request = Request.new

    respond_to do |format|
      format.html
      format.json { render json: @request }
    end
  end
  
  def create
    @user = current_user
    @attendance = Attendance.find(params[:attendance_id])
    if @attendance.user_id
      @request = Request.create(:user_id => @user.id, :receiver => params[:attendance_id],
                                :invitee_registered => true, :body => params[:request][:body])
    else
      @request = Request.create(:user_id => @user.id, :email => @attendance.registered_email,
                                :invitee_registered => false, :body => params[:request][:body])
    end
    respond_to do |format|
      format.html {
        @request.save
        redirect_to conference_attendee_path(@attendance.conference_id, params[:attendance_id])
      }
      format.json {
        if (@request.save)
          render json: @request, status: :created, location: @request
        else
          render json: @request.errors, status: :unprocessable_entity
        end
      }
    end
  end
  
  # def destroy
  #   @request = Request.find(params[:id])
  #   @attendance = Attendance.find(@like.attendance_id)
  #   @like.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to conference_attendee_path(@attendance.conference_id, @attendance.id) }
  #     format.json { head :no_content }
  #   end
  # end

end
