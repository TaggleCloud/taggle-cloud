class Connection < ActiveRecord::Base
  attr_accessible :attendance1_id, :attendance2_id, :strength, :abstract_strength, :keyword_strength

  belongs_to :attendance, :class_name => "Attendance", :foreign_key => "attendance1_id"
  has_one :attendance, :class_name => "Attendance", :foreign_key => "attendance2_id"

  def self.includes_user(user)
    return Attendance.find_by_id(self.attendance1_id).user == user || Attendance.find_by_id(self.attendance2_id).user == user
  end

  def self.get_connection(first_attendance_id, second_attendance_id)
    return Connection.find(:all, :conditions => "attendance1_id = #{first_attendance_id} AND attendance2_id = #{second_attendance_id}")
  end

  def self.compare(tags1, tags2)
    intersection = tags1 & tags2
    return 0 if intersection.size == tags1.size && intersection.size == tags2.size # Probably want to change this eventually
    shorter = (tags1.size > tags2.size ? tags2.size : tags1.size)
    # logger.info("comparing #{tags1.map(&:value).join(",")}\n, against #{tags2.map(&:value).join(",")}\n, intersection = #{intersection.map(&:value).join(",")}, \n shorter = #{shorter.size}\n")
    return 0 if shorter == 0
    return ((intersection.size * 1.0) / (tags1.size * 1.0)) * 100 # divides by current user's size instead of shorter
  end

  def self.build_conf_connections(conf)
    atts = conf.attendances.all
    atts.each_with_index do |atnd, index|
      atts.each do |comp_atnd|
        next if atnd.id == comp_atnd.id
        tagset1keys, tagset1abs, tagset2 = [], [], [], []
        atnd.abstracts.all.each do |abstract|
          if !abstract.user_id.nil?
            # Include bio when comparing
            # Bio no longer being used
            # bio = Abstract.where(:user_id => abstract.user_id, :is_bio => true).first
            # if bio
            #   bio.abstract_tags.all.each do |bio_tag|
            #     tagset1bio << bio_tag.tag if bio_tag.tag
            #   end
            # end
            keys = Abstract.where(:user_id => abstract.user_id, :keywords => true).first
            if keys
              keys.abstract_tags.all.each do |keys_tag|
                tagset1keys << keys_tag.tag if keys_tag.tag
              end
            end
          end
          abstract.abstract_tags.all.each do |abstract_tag|
            tagset1abs << abstract_tag.tag if abstract_tag.tag
            # self.my_logger.info("original atnd has #{abstract_tag.tag.value}") if abstract_tag.tag
          end
        end
        comp_atnd.abstracts.all.each do |abstract|
          if !abstract.user_id.nil?
            # Include bio when comparing
            # Bio no longer being used
            # bio = Abstract.where(:user_id => abstract.user_id, :is_bio => true).first
            # if bio
            #   bio.abstract_tags.all.each do |bio_tag|
            #     tagset2 << bio_tag.tag if bio_tag.tag
            #   end
            # end
            keys = Abstract.where(:user_id => abstract.user_id, :keywords => true).first
            if keys
              keys.abstract_tags.all.each do |keys_tag|
                tagset2 << keys_tag.tag if keys_tag.tag
              end
            end
          end
          abstract.abstract_tags.all.each do |abstract_tag|
            tagset2 << abstract_tag.tag if abstract_tag.tag
            # self.my_logger.info("comp_atnd has #{abstract_tag.tag.value}") if abstract_tag.tag
          end
        end
        conn = self.find_or_create_by_attendance1_id_and_attendance2_id(atnd.id, comp_atnd.id)
        # Bio no longer being used
        # bio_str = self.compare(tagset1bio, tagset2)
        keys_str = self.compare(tagset1keys, tagset2)
        abs_str = self.compare(tagset1abs, tagset2)
        str = (keys_str * 0.5) + (abs_str * 0.5)
        conn.update_attributes(:strength => str, :abstract_strength => abs_str, :keyword_strength => keys_str)
      end
    end
  end

  def self.refresh_conf_connections(conf, usr_id)
    atts = conf.attendances.all
    atnd = conf.attendances.where(:user_id => usr_id).first
    atts.each do |comp_atnd|
      next if atnd.id == comp_atnd.id
      tagset1keys, tagset1abs, tagset2 = [], [], [], []
      atnd.abstracts.all.each do |abstract|
        if !abstract.user_id.nil?
          # Include bio when comparing
          # Bio no longer being used
          # bio = Abstract.where(:user_id => abstract.user_id, :is_bio => true).first
          # if bio
          #   bio.abstract_tags.all.each do |bio_tag|
          #     tagset1bio << bio_tag.tag if bio_tag.tag
          #   end
          # end
          keys = Abstract.where(:user_id => abstract.user_id, :keywords => true).first
          if keys
            keys.abstract_tags.all.each do |keys_tag|
              tagset1keys << keys_tag.tag if keys_tag.tag
            end
          end
        end
        abstract.abstract_tags.all.each do |abstract_tag|
          tagset1abs << abstract_tag.tag if abstract_tag.tag
          # self.my_logger.info("original atnd has #{abstract_tag.tag.value}") if abstract_tag.tag
        end
      end
      comp_atnd.abstracts.all.each do |abstract|
        if !abstract.user_id.nil?
          # Include bio when comparing
          # Bio no longer being used
          # bio = Abstract.where(:user_id => abstract.user_id, :is_bio => true).first
          # if bio
          #   bio.abstract_tags.all.each do |bio_tag|
          #     tagset2 << bio_tag.tag if bio_tag.tag
          #   end
          # end
          keys = Abstract.where(:user_id => abstract.user_id, :keywords => true).first
          if keys
            keys.abstract_tags.all.each do |keys_tag|
              tagset2 << keys_tag.tag if keys_tag.tag
            end
          end
        end
        abstract.abstract_tags.all.each do |abstract_tag|
          tagset2 << abstract_tag.tag if abstract_tag.tag
          # self.my_logger.info("comp_atnd has #{abstract_tag.tag.value}") if abstract_tag.tag
        end
      end
      conn = self.find_or_create_by_attendance1_id_and_attendance2_id(atnd.id, comp_atnd.id)
      # Bio no longer being used
      # bio_str = self.compare(tagset1bio, tagset2)
      keys_str = self.compare(tagset1keys, tagset2)
      abs_str = self.compare(tagset1abs, tagset2)
      str = (keys_str * 0.5) + (abs_str * 0.5)
      conn.update_attributes(:strength => str, :abstract_strength => abs_str, :keyword_strength => keys_str)
    end
  end
end
