class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    # Bio no longer being used
    # @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
    @keys = Abstract.where(:user_id => @user.id, :keywords => true).first
    @conferences = @user.get_conferences
  end

  def edit
    @user = User.find(params[:id])
    # Bio no longer being used
    # @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
    @keys = Abstract.where(:user_id => @user.id, :keywords => true).first
    #@user.emails.build
    unless @user.is_admin || @user == current_user
      flash[:notice] = "You have no right to edit this user"
      redirect_to user_path(@user)
    end
  end
  
  def promote
    # form
    @user = User.find(params[:user_id])
    @users = User.all
    unless @user.is_admin
      flash[:notice] = "You have no right to edit this user"
      redirect_to user_path(@user)
    end
  end
  
  def promote_user
    # actual action
    @user = User.find(params[:user][:id])
    @users = User.all
    respond_to do |format|
      if (params[:user][:conf_left].blank?)   
        format.html { 
          flash[:notice] = 'Conference Limit left blank'
          render action: "promote"
        }   
        format.json { render json: @user.errors, status: :unprocessable_entity }
      elsif @user.update_attributes(params[:user])  
        format.html { redirect_to @user, notice: 'User was successfully promoted.' }
        format.json { render json: @user }  
      else
        format.html { render action: "promote" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def dashboard
    @user = current_user
    @user_conferences = current_user.get_conferences
    @conferences = Conference.all.reject{|conf| @user_conferences.include? conf}
    
    @curr_attendances = []
    @upcoming_attendances = []
    @past_attendances = []
    current_user.attendances.all.each do |att|
      conf = Conference.find_by_id(att.conference_id)
      if (conf && !@user_conferences.include?(conf)) # filters out Users current conferences from main list
        # Place holder
        @attendees = conf.attendances
        @conference = conf
        
        if (conf.start_time <= Date.today) && (conf.end_time >= Date.today)
          @curr_attendances << att
        elsif (conf.start_time > Date.today) 
          @upcoming_attendances << att
        elsif (conf.end_time < Date.today) 
          @past_attendances << att
        end
      end
    end
    # Bio no longer being used
    # @bio = Abstract.where(:user_id => current_user.id, :is_bio => true).first
    
    @like_count = Like.where("user_id = ?", current_user.id).count
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update
    @user = current_user
    # Bio no longer being used
    # @bio = Abstract.where(:user_id => @user.id, :is_bio => true).first
    @abstracts = Abstract.where(:user_id => @user.id)
    @abstracts.each do |abs|
      if abs.body.blank?
        Abstract.update(abs.id, :body => params["user"]["bio"])
      end
    end
    
    @keys = Abstract.where(:user_id => @user.id, :keywords => true).first
    # Abstract.update(@bio.id, :body => params["user"]["abstract"]["body"])
    Abstract.update(@keys.id, :body => params["user"]["abstract"]["body"])
    
    @emails = Email.where(:user_id => @user.id)
    
    params["user"].delete("abstract")
    respond_to do |format|
      if @user.update_attributes(params[:user])
        @emails.each do |e|
          @user.attach_att(e.mail_address)
          @user.attach_request(e.mail_address)
        end
        format.html { redirect_to user_path(@user.id), notice: 'Profile has been successfully updated.' }
        format.json { render json: @user }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
