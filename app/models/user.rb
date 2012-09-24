class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid

  has_many :abstracts
  has_many :connections
  has_many :attendances
  has_many :emails

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end
end
