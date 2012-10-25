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
    @abstract = Abstract.new
    
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
