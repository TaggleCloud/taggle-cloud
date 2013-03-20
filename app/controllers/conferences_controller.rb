class ConferencesController < ApplicationController
  # GET /conferences
  # GET /conferences.json
  def index
    if current_user
      @conferences = current_user.get_conferences
    else
      return redirect_to root_path
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conferences }
    end
  end

  # GET /conferences/1
  # GET /conferences/1.json
  def show
    @conference = Conference.find(params[:id])
    @user_attendance = current_user.attendances.where(:conference_id => @conference.id).last if current_user
    @likes = current_user.likes.where(:conference_id => @conference.id).all
    @liked_attendees = []
    @likes.each do |like|
      @liked_attendees << like.attendance
    end
    @liked_count = @likes.count
    if @user_attendance
      @connections = Connection.find(:all, :conditions => "attendance1_id = #{@user_attendance.id}", :order => 'strength DESC')
      @attendees = []
      @connections.each do |c|
        @attendees << Attendance.find(c.attendance2_id)
      end
    else
      @attendees = @conference.attendances
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference }
    end
  end

  def connections
    @conference = Conference.find(params[:conference_id])
    @connections = @conference.attendances.connections_for_user(current_user)
  end

  # GET /conferences/new
  # GET /conferences/new.json
  def new
    @conference = Conference.new
    unless current_user.is_admin
      flash[:notice] = "You have no right to create a conference"
      return redirect_to conferences_path
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /conferences/1/edit
  def edit
    @conference = Conference.find(params[:id])
    unless current_user.is_admin || current_user.coordinate(@conference)
      flash[:notice] = "You have no right to edit this conference"
      return redirect_to conference_path
    end
  end

  def attendee
    @attendance = @conference.attendances.build
  end

  # POST /conferences
  # POST /conferences.json
  def create
    @conference = Conference.create(:location => params[:conference][:location], :name => params[:conference][:name])
    @conference.upload(params[:conference][:csv], current_user)
    @email = params[:conference][:email]

    respond_to do |format|
      if @conference.save
        format.html { redirect_to @conference, notice: 'Conference was successfully created.' }
        format.json { render json: @conference, status: :created, location: @conference }
      else
        format.html { render action: "new" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update
    @conference = Conference.find(params[:id])
    puts params

    respond_to do |format|
      if @conference.update_attributes(params[:conference])
        format.html { redirect_to @conference, notice: 'Conference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.json
  def destroy
    @conference = Conference.find(params[:id])
    @conference.destroy

    respond_to do |format|
      format.html { redirect_to conferences_url }
      format.json { head :no_content }
    end
  end
end
