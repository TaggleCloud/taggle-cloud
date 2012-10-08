class AbstractAttendance < ActiveRecord::Migration
  def change
    rename_column :abstracts, :conference_id, :attendance_id
  end
end
