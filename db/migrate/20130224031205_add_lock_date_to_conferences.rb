class AddLockDateToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :lock_date, :datetime
  end
end
