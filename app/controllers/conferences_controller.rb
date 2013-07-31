class ConferencesController < ApplicationController
  # GET /conferences
  # GET /conferences.json
  def index
    if current_user
      if current_user.is_admin
        @conferences = Conference.all
      else
        @conferences = current_user.get_conferences
      end
      @curr_conferences = []
      @upcoming_conferences = []
      @past_conferences = []
      @conferences.each do |conf|
        if (conf.start_time <= Date.today) && (conf.end_time >= Date.today)
          @curr_conferences << conf
        elsif (conf.start_time > Date.today) 
          @upcoming_conferences << conf
        elsif (conf.end_time < Date.today) 
          @past_conferences << conf
        end
      end
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
    @user_abstract = current_user.abstracts.where(:attendance_id => @user_attendance.id).last if current_user && @user_attendance
    # Choose whether to sort by keyword or abstract
    @sort_by_keyword = !current_user.abstracts.first.body.to_s.empty?

    @likes = current_user.likes.where(:conference_id => @conference.id).all
    @liked_attendees = []
    @likes.each do |like|
      @liked_attendees << like.attendance
    end
    @liked_count = @likes.count
    if @user_attendance
      if @sort_by_keyword
        @connections = Connection.find(:all, :conditions => "attendance1_id = #{@user_attendance.id}", :order => 'keyword_strength DESC')
        # Set variable for showing a notice about setting better keywords:
        @trivial_keywords = @connections.select { |c| c.keyword_strength if (c.keyword_strength == 100) }.count / (1.0 * @connections.count)
      else
        @connections = Connection.find(:all, :conditions => "attendance1_id = #{@user_attendance.id}", :order => 'abstract_strength DESC')
      end
      @attendees = []
      @attendees_unmatched = []
      @connections.each do |c|
        # Filter out keyword strength 0
        if @sort_by_keyword 
          if c.keyword_strength == 0
            @attendees_unmatched << Attendance.find(c.attendance2_id)
          else
            @attendees << Attendance.find(c.attendance2_id)
          end
        else
          if c.abstract_strength > 0
            @attendees << Attendance.find(c.attendance2_id)
          end
        end
      end
      if !@attendees_unmatched.empty?
        @attendees_unmatched.sort! { |a,b| b.get_abstract_strength(@user_attendance) <=> a.get_abstract_strength(@user_attendance) } if @user_attendance
      end
    else
      @attendees = @conference.attendances
      @attendees_unmatched = []
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
    # Convert times from date picker. First split then call Date.new
    if params[:conference]["start_time"] && params[:conference]["start_time"].length > 0
      start_time_split = params[:conference]["start_time"].split('-')
      start_time_conv = Date.new(start_time_split[0].to_i,
                                 start_time_split[1].to_i,
                                 start_time_split[2].to_i)
    end
    if params[:conference]["end_time"] && params[:conference]["start_time"].length > 0
      end_time_split = params[:conference]["end_time"].split('-')
      end_time_conv = Date.new(end_time_split[0].to_i,
                               end_time_split[1].to_i,
                               end_time_split[2].to_i)
    end
    if params[:conference]["lock_date"] && params[:conference]["start_time"].length > 0
      lock_date_split = params[:conference]["lock_date"].split('-')
      lock_date_conv = Date.new(lock_date_split[0].to_i,
                                lock_date_split[1].to_i,
                                lock_date_split[2].to_i)
    end

    
    @conference = Conference.create(:location => params[:conference][:location], :name => params[:conference][:name], :start_time => start_time_conv, :end_time => end_time_conv, :lock_date => lock_date_conv)

    # Rails.logger.debug("params[:conference][:start_time] = #{params[:conference][:start_time]}")
    if params[:conference][:csv]
      @conference.upload(params[:conference][:csv], current_user)
    end
    @email = params[:conference][:email]

    @attendances = @conference.attendances
    @attendances.each do |a|
      a.abstracts.each do |abs|
        if a.user_id && abs.body.blank?
          Abstract.update(abs.id, :body => a.user.bio)
        end
      end
    end


    # This is the commented out emailer that emails everyone when they are registered for a conference
    # @conference.attendances.each do |a|
    #       UserMailer.conference_email(a, @conference).deliver
    #     end
    respond_to do |format|
      if params[:conference][:csv] && @conference.save
        format.html { redirect_to @conference, notice: 'Conference was successfully created.' }
        format.json { render json: @conference, status: :created, location: @conference }
      else
        @conference.destroy
        format.html {
          flash.now[:error] = 'csv not uploaded'
          render action: "new"
        }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update
    @conference = Conference.find(params[:id])
    @conference.update_conference

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
