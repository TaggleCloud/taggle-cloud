class UsersToAttendances < ActiveRecord::Migration
  def change
    rename_column :connections, :user1_id, :attendance1_id
    rename_column :connections, :user2_id, :attendance2_id
  end
end
