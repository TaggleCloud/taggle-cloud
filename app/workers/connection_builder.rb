class ConnectionBuilder
  include Sidekiq::Worker
  
  def perform(conference, attendance)
    # Build the primary person's tagset that will be compared to everyone else
    primary_tagset = get_tagset(attendance)
    # Time to go through all the other attendees and make connections
    conference.attendances.each do |comp_attendance|
      next if attendance.id == comp_attendance.id
      comp_tagset = get_tagset(comp_attendance)
      Connection.create(:attendance1_id => attendance.id,
                        :attendance2_id => comp_attendance.id,
                        :strength => Connection.compare(primary_tagset, comp_tagset))
    end
  end

  def get_tagset(attendee)
    tagset = []
    attendee.abstracts.each do |abstract|
      abstract.abstract_tags.each do |abstract_tag|
        tagset << abstract_tag.tag if !tagset.include? abstract_tag.tag.to_s
      end
    end
    return tagset
  end

end