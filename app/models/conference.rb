require 'csv'

class Conference < ActiveRecord::Base
  attr_accessible :name, :location, :attendances_attributes

  has_many :attendances
  has_many :connections, :through => :attendances
  
  accepts_nested_attributes_for :attendances
  
  def upload(uploaded_io)
    CSV.parse(uploaded_io.read) do |row|
      logger.info("x" * 100 + "\n" + row.to_s)
      AttendanceImporter.perform_async(self.id,row)
    end
  end

end
