class AddProjectNameToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :project_name, :string
  end
end
