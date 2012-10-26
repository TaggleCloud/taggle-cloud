class AddStartDateAndEndDateToConference < ActiveRecord::Migration
  def change
    add_column :conferences, :start_time, :datetime
    add_column :conferences, :end_time, :datetime
  end
end
