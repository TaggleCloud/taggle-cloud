class LandingsController < ApplicationController
  def home
    render :layout => "landing"
  end
end