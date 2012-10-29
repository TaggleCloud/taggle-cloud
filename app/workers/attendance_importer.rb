# require 'sidekiq/testing'

class AttendanceImporter
  include Sidekiq::Worker
  sidekiq_options :queue => 'default'
  
  REDIS_POOL = ConnectionPool.new(:size => 10, :timeout => 3) { Redis.new }
  def perform(args)
    REDIS_POOL.with_connection do |redis|
      redis.lsize(:foo)
    end
  end
  
  def perform(conference_id, row)
    if row[5] && valid_email(row[5])
      new_attendee = Attendance.create( :registered_email => row[5],
                                        :conference_id => conference_id,
                                        :first_name => row[3],
                                        :last_name => row[4],
                                        :organization => row[2])
      
      e = Email.where(:mail_address => row[5]).first
      new_attendee.user_id = e.user_id if e
      
      abstract = sanitize_string(row[7]) if row[7]
      Abstract.create(:body => abstract, :attendance_id => new_attendee.id, :user_id => new_attendee.user_id) if abstract
    end
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
