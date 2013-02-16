class Preference < ActiveRecord::Base
  attr_accessible :category, :content

  belongs_to :attendance
  

  

end
