class ChangeConferenceDateTimesToDates < ActiveRecord::Migration
  def change
    change_column :conferences, :start_time, :date
    change_column :conferences, :end_time, :date
    change_column :conferences, :lock_date, :date
  end
end
