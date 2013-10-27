class AddAbstractBodyToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :abstract_body, :string
  end
end
