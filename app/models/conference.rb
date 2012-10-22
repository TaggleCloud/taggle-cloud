require 'csv'

class Conference < ActiveRecord::Base
  attr_accessible :name, :location

  has_many :attendances
  has_many :connections, :through => :attendances
  
  def upload(uploaded_io)
    CSV.parse(uploaded_io.read) do |row|
      AttendanceImporter.perform_async(self,row)
    end
  end

end