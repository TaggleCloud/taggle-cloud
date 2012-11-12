class LandingsController < ApplicationController
  def home
    @attendee_count = Attendance.count
    @connection_count = Connection.count
    @conference_count = Conference.count
    render :layout => "landing"
  end
end