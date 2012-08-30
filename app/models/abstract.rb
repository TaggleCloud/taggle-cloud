require 'levenshtein'

class Abstract < ActiveRecord::Base
  attr_accessible :body, :user_id

  belongs_to :user
  belongs_to :conference
  has_many :tags
  
  #http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#Ruby
  def levenshtein(b)
    Levenshtein.distance(self.body, b.body)
  end
end
