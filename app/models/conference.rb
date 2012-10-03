require 'csv'

class Conference < ActiveRecord::Base
  attr_accessible :location

  has_many :attendances
  has_many :abstracts
  
  def upload(uploaded_io)
    CSV.parse(uploaded_io.read).each do |row| 
      at = nil
      if row[5] != nil
        at = Attendance.new(:registered_email => row[5], :conference_id => self.id)
        e = Email.where(:mail_address => row[5]).first
        if e
          at.user_id = e.user_id
        end
        at.save
      end
      if row[7] && at
        ab = Abstract.new(:body => row[7], :attendance_id => at.id, :user_id => at.user_id)
        ab.save
      end
    end
  end
end
