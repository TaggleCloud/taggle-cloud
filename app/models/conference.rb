class Conference < ActiveRecord::Base
  attr_accessible :location

  has_many :attendances
  has_many :abstracts
end
