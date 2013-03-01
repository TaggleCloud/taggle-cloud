class AddBiosToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :bio, :text
  end
end
