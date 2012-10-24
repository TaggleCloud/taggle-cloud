class Connection < ActiveRecord::Base
  attr_accessible :attendance1_id, :attendance2_id, :strength

  belongs_to :attendance, :class_name => "Attendance", :foreign_key => "attendance1_id"
  has_one :attendance, :class_name => "Attendance", :foreign_key => "attendance2_id"
  
  def self.includes_user(user)
    return Attendance.find_by_id(self.attendance1_id).user == user || Attendance.find_by_id(self.attendance2_id).user == user
  end

  def self.get_connection(first_attendance_id, second_attendance_id)
    return Connection.find(:all, :conditions => "attendance1_id = #{first_attendance_id} AND attendance2_id = #{second_attendance_id}")
  end

  def self.my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/logfile.log")
  end
  
  # def self.build_conf_connections(conf)
  #   atts = conf.attendances
  #   atts.each_with_index do |atnd, index|
  #     atts.drop(index).each do |comp_atnd|
  #       next if atnd.id == comp_atnd.id
  #       tagset1, tagset2 = [], []
  #       atnd.abstracts.all.each do |abstract|
  #         abstract.abstract_tags.all.each do |abstract_tag|
  #           tagset1 << abstract_tag.tag if abstract_tag.tag
  #           # self.my_logger.info("original atnd has #{abstract_tag.tag.value}") if abstract_tag.tag
  #         end
  #       end
  #       comp_atnd.abstracts.all.each do |abstract|
  #         abstract.abstract_tags.all.each do |abstract_tag|
  #           tagset2 << abstract_tag.tag if abstract_tag.tag
  #           # self.my_logger.info("comp_atnd has #{abstract_tag.tag.value}") if abstract_tag.tag
  #         end
  #       end
  #       # self.my_logger.info("Comparing tag for #{atnd.id}, #{comp_atnd.id}, since compare returned #{self.compare(tagset1, tagset2)}")
  #       self.create(:attendance1_id => atnd.id, :attendance2_id => comp_atnd.id, :strength => self.compare(tagset1, tagset2))
  #     end
  #   end
  # end
  
  def self.compare(tags1, tags2)
    intersection = tags1 & tags2
    return 0 if intersection.size == tags1.size && intersection.size == tags2.size # Probably want to change this eventually
    shorter = (tags1.size > tags2.size ? tags2.size : tags1.size)
    self.my_logger.info("comparing #{tags1.map(&:value).join(",")}\n, against #{tags2.map(&:value).join(",")}\n, intersection = #{intersection.map(&:value).join(",")}, \n shorter = #{shorter.size}\n")
    return 0 if shorter == 0
    return ((intersection.size * 1.0) / (shorter * 1.0)) * 100
  end
end
