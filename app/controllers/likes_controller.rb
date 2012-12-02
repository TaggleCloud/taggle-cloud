class LikesController < ApplicationController
  # POST /likes
  # POST /likes.json
  def create
    @attendance = Attendance.find(params[:attendance_id])
    @like = Like.new(:attendance_id => @attendance.id, :user_id => current_user.id, :conference_id => @attendance.conference.id)
    logger.info(@like.attendance_id.to_s + " " + @like.user_id.to_s)
    respond_to do |format|
      format.html {
        @like.save
        redirect_to conference_attendee_path(@attendance.conference_id, params[:attendance_id])
      }
      format.json {
        if (@like.save)
          render json: @like, status: :created, location: @like
        else
          render json: @like.errors, status: :unprocessable_entity
        end
      }
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    @like = Like.find(params[:id])
    @attendance = Attendance.find(@like.attendance_id)
    @like.destroy

    respond_to do |format|
      format.html { redirect_to conference_attendee_path(@attendance.conference_id, @attendance.id) }
      format.json { head :no_content }
    end
  end
end
