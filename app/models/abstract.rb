require 'levenshtein'

class Abstract < ActiveRecord::Base
  after_create TagsetBuilder.perform_async(self)
  attr_accessible :body, :user_id, :attendance_id

  belongs_to :user
  belongs_to :attendance
  has_many :abstract_tags
  
  #http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#Ruby
  def levenshtein(b)
    Levenshtein.distance(self.body, b.body)
  end
  
end
