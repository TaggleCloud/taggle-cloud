require 'sidekiq/testing'

class ConnectionBuilder
  include Sidekiq::Worker
  
  def perform(conference_id, attendance_id)
    # Build the primary person's tagset that will be compared to everyone else
    primary_tagset = get_tagset(attendance_id)
    # Time to go through all the other attendees and make connections
    conference = Conference.find(conference_id)
    conference.attendances.each do |comp_attendance|
      next if attendance_id == comp_attendance.id
      comp_tagset = get_tagset(comp_attendance.id)
      Connection.create(:attendance1_id => attendance_id,
                        :attendance2_id => comp_attendance.id,
                        :strength => Connection.compare(primary_tagset, comp_tagset))
    end
  end

  def get_tagset(attendee_id)
    tagset = []
    attendee = Attendance.find(attendee_id)
    attendee.abstracts.each do |abstract|
      abstract.abstract_tags.each do |abstract_tag|
        tagset << abstract_tag.tag if !tagset.include? abstract_tag.tag.to_s
      end
    end
    return tagset
  end

end