class RequestsController < ApplicationController
  
  def index
    @user = current_user
    @requests = @user.requests
  end
  
  def notifications
    @user = current_user
    @notifications = @user.get_notifications
  end
  
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
      @request = Request.create(:inviter => @user.id, :user_id => params[:attendance_id],
                                :invitee_registered => true, :body => params[:request][:body])
    else
      @request = Request.create(:inviter => @user.id, :email => @attendance.registered_email,
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
  
  def edit
    @user = current_user
    @request = Request.find(params[:id])
    if @request.user_id != @user.id
      flash[:notice] = "You have no right to edit this request"
      return redirect_to requests_path
    end
  end
  
  def update
    @request = Request.find(params[:id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to requests_path, notice: 'Reply was successfully sent.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # Response Actions: Accept, reply, ignore
  
  def accept
    @user = current_user
    flash[:notice] = "You have accepted a request from #{User.find(params[:id]).name}"
    @request = Request.where('user_id = ? AND inviter = ?', @user.id, params[:id]).first    
    @request.accepted = true
    @request.save
    respond_to do |format|
      format.html {
        redirect_to requests_path
      }
    end
  end
  
  def reply
    @user = current_user
    flash[:notice] = "REPLY"
    respond_to do |format|
      format.html {
        redirect_to requests_path
      }
    end
  end
  
  def ignore
    @user = current_user
    flash[:notice] = "You have ignored a request from #{User.find(params[:id]).name}"
    @request = Request.where('user_id = ? AND inviter = ?', @user.id, params[:id]).first    
    @request.accepted = false
    @request.save
    respond_to do |format|
      format.html {
        redirect_to requests_path
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
