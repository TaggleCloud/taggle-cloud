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

  def dashboard
    @conferences = current_user.get_conferences
    @past_attendances = []
    @curr_attendances = []
    current_user.attendances.all.each do |att|
      conf = Conference.find_by_id(att.conference_id)
      if (conf.end_time < Date.today) 
        @past_attendances << att
      else
        @curr_attendances << att
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
    @keys = Abstract.where(:user_id => @user.id, :keywords => true).first
    # Abstract.update(@bio.id, :body => params["user"]["abstract"]["body"])
    Abstract.update(@keys.id, :body => params["user"]["abstract"]["body"])
    params["user"].delete("abstract")
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to user_path(@user.id), notice: 'Profile has been successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end
end
