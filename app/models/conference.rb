require 'csv'
require 'iconv'

class Conference < ActiveRecord::Base
  attr_accessible :name, :location

  has_many :attendances
  has_many :connections, :through => :attendances
  
  def upload(uploaded_io)

    attendances, abstracts = [], []

    CSV.parse(uploaded_io.read) do |row|
      if row[5] && valid_email(row[5])
        attendances << Attendance.new(:registered_email => row[5], :conference_id => self.id, :first_name => row[3], :last_name => row[4], :organization => row[2])
        # e = Email.where(:mail_address => row[5]).first
        # if e
        #   at.user_id = e.user_id
        # end
        abstract = sanitize_string(row[7]) if row[7]
        if abstract
          abstracts << Abstract.new(:body => abstract, :attendance_id => at.id, :user_id => at.user_id)
        end
      end
    end
    # Connection.csv_upload_builder(self)

    Attendance.import(attendances)
    Abstract.import(abstracts)
  end

  def valid_email(email)
    return /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/.match(email)
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