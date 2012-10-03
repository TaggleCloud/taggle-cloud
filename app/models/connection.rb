class Connection < ActiveRecord::Base
  attr_accessible :conference_id, :attendance1_id, :attendance2_id

  belongs_to :attendance
  has_one :attendance
  
  def csv_upload_builder(conf)
    for conf.attendances.all.each do |atnd|
      for conf.attendances.all.each do |comp_atnd|
        if compare (atnd.abstracts.all.each.tags.all, comp-atnd.abstracts.all.each.tags.all)
          Connection.create (:conference => conf.id, :user1)
        end
      end
    end
  end
end
