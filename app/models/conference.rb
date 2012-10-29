require 'csv'

class Conference < ActiveRecord::Base
  attr_accessible :name, :location, :attendances_attributes

  has_many :attendances
  has_many :connections, :through => :attendances
 
  accepts_nested_attributes_for :attendances
  
  def upload(uploaded_io)
    attendances, abstracts = [], []
    CSV.parse(uploaded_io.read) do |row|
      if row[5] && valid_email(row[5])
        @att = Attendance.create(:registered_email => row[5], :conference_id => self.id, :first_name => row[3], :last_name => row[4], :organization => row[2])
        e = Email.where(:mail_address => row[5]).first
        @att.user_id = e.user_id if e
        abstract = sanitize_string(row[7]) if row[7]
        Abstract.create(:body => abstract, :attendance_id => @att.id, :user_id => @att.user_id) if abstract
      end
      # Attendance.import(attendances)
      # Abstract.import(abstracts)
      Connection.build_conf_connections(self)
      
      #AttendanceImporter.perform_in(5.seconds, self.id, row)
    end
  end
  
  def valid_email(email)
    return /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/.match(email)
  end
  
  def sanitize_string(untrusted_string)
    untrusted_string.unpack('C*').pack('U*')
    # if String.method_defined?(:encode)
    # untrusted_string.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    # else
    # ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
    # untrusted_string = ic.iconv(untrusted_string)
    # end
  end

end
