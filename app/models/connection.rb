class Connection < ActiveRecord::Base
  attr_accessible :attendance1_id, :attendance2_id, :strength

  belongs_to :attendance, :class_name => "Attendance", :foreign_key => "attendance1_id"
  has_one :attendance, :class_name => "Attendance", :foreign_key => "attendance2_id"
  
  def self.includes_user(user)
    return Attendance.find_by_id(self.attendance1_id).user == user || Attendance.find_by_id(self.attendance2_id).user == user
  end

  def self.get_connection(first_attendace_id, second_attendance_id)
    return Connection.where(attendance1_id = first_attendance_id, attendance2_id = second_attendance_id)
  end

  def self.compare(tags1, tags2)
    intersection = tags1 & tags2
    return 0 if intersection.size == tags1.size && intersection.size == tags2.size # Probably want to change this eventually
    shorter = (tags1.size > tags2.size ? tags2.size : tags1.size)
    # logger.info("comparing #{tags1.map(&:value).join(",")}\n, against #{tags2.map(&:value).join(",")}\n, intersection = #{intersection.map(&:value).join(",")}, \n shorter = #{shorter.size}\n")
    return 0 if shorter == 0
    return ((intersection.size * 1.0) / (shorter * 1.0)) * 100
  end
end
