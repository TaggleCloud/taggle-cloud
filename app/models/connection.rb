class Connection < ActiveRecord::Base
  attr_accessible :conference_id, :attendance1_id, :attendance2_id

  belongs_to :attendance
  has_one :attendance
  
  def self.my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/fuck.you")
  end
  
  def self.csv_upload_builder(conf)
    atts = conf.attendances
    atts.each do |atnd|
      atts.each do |comp_atnd|
        tagset1 = Array.new
        tagset2 = Array.new
        atnd.abstracts.all.each do |abstract|
          abstract.abstract_tags.all.each do |abstract_tag|
            tagset1 << abstract_tag.tag
          end
        end
        comp_atnd.abstracts.all.each do |abstract|
          abstract.abstract_tags.all.each do |abstract_tag|
            tagset2 << abstract_tag.tag
          end
        end
            self.my_logger.info("comparing tag for #{atnd.id}, #{comp_atnd.id}, since compare returned #{self.compare(tagset1, tagset2)}")
        if self.compare(tagset1, tagset2) > 80
          self.create(:conference_id => conf.id, :attendance1_id => atnd.id, :attendance2_id => comp_atnd.id)
        end 
      end
    end
  end
  
  private
  
  def self.compare(tags1, tags2)
    intersection = tags1 & tags2
    shorter = (tags1.size > tags2.size ? tags2.size : tags1.size)
        self.my_logger.info("comparing #{tags1.class}, #{tags2.class}, intersection = #{intersection.size}, shorter = #{shorter.size}")
    return 0 if shorter == 0
    return (intersection.size * 1.0 / shorter * 1.0) * 100
  end
end
