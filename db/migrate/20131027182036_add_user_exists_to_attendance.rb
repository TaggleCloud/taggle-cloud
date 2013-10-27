class AddUserExistsToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :user_exists, :boolean
  end
end
