require 'csv'
require 'iconv'

class Conference < ActiveRecord::Base
  attr_accessible :location

  has_many :attendances
  
  def upload(uploaded_io)
    CSV.parse(uploaded_io.read) do |row|
      if row[5] && row[5] != "PI Email"
        at = Attendance.new(:registered_email => row[5], :conference_id => self.id)
        e = Email.where(:mail_address => row[5]).first
        if e
          at.user_id = e.user_id
        end
        at.save
        abstract = sanitize_string(row[7]) if row[7]
        if abstract
          ab = Abstract.new(:body => abstract, :attendance_id => at.id, :user_id => at.user_id)
          ab.save
        end
      end
    end
    Connection.csv_upload_builder(self)
  end
  
  def sanitize_string(untrusted_string)
    untrusted_string.unpack('C*').pack('U*')
    # if String.method_defined?(:encode)
    #   untrusted_string.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    # else
    #   ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
    #   untrusted_string = ic.iconv(untrusted_string)
    # end
  end
end
