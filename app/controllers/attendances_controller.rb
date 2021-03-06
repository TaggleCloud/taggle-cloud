class AttendancesController < ApplicationController
  # GET /attendances
  # GET /attendances.json
  def index
    @conference = Conference.find(params[:conference_id])
    @attendees = @conference.attendances

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attendees }
    end
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
    @conference = Conference.find(params[:conference_id])
    @attendance = Attendance.find(params[:id])
    @abstracts = @attendance.abstracts
    @like = Like.where("attendance_id = ? AND user_id = ?", @attendance.id, current_user.id).first
    @like_count = Like.where("attendance_id = ? AND user_id = ?", @attendance.id, current_user.id).count
    if(@attendance.user_id)
      @user = User.find(@attendance.user_id)
      # @keys = Abstract.where(:user_id => @user.id, :keywords => true).first
      @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
      @conferences = @user.get_conferences
    end
    if(current_user)
      @user_attendance = Attendance.where(:conference_id => @conference.id, :user_id => current_user.id).first
      if @user_attendance.nil?
        flash[:notice] = "You have no right to view this attendee"
        return redirect_to conferences_path
      end
      @connection = Connection.where(:attendance1_id => @user_attendance.id, :attendance2_id => params[:id]).first
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :attendee => @attendance,
                                   :abstracts => @abstracts } }
    end
  end

  # GET /attendances/new
  # GET /attendances/new.json
  def new
    @attendance = Attendance.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attendance }
    end
  end

  # GET /attendances/1/edit
  def edit
    @attendance = Attendance.find(params[:id])
  end

  # POST /attendances
  # POST /attendances.json
  def create
    @attendance = Attendance.create(params[:attendance])
    
    respond_to do |format|
      if @attendance.save          
        format.html { redirect_to @attendance, notice: 'Attendance was successfully created.' }
        format.json { render json: @attendance, status: :created, location: @attendance }
      else
        format.html { render action: "new" }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attendances/1
  # PUT /attendances/1.json
  def update
    @attendance = Attendance.find(params[:id])

    respond_to do |format|
      if @attendance.update_attributes(params[:attendance])
        format.html { redirect_to @attendance, notice: 'Attendance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    #TODO Jbender will fix this later to use destroy instead of delete
    @attendance = Attendance.find(params[:id])
    @conference = Conference.find(@attendance.conference_id)
    # Delete connected connections
    @attendance.connections.delete_all
    @connections = Connection.find(:all, :conditions => "attendance2_id = #{@attendance.id}")
    @connections.each do |c|
      c.delete
    end
    
    @attendance.delete
    @attendees = @conference.attendances

    respond_to do |format|
      format.html { redirect_to @conference, notice: 'Attendance successfully deleted' }
      format.json { render json: @conference }
    end
  end
end
