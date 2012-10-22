class AddNamesAndOrganizationToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :first_name, :string
    add_column :attendances, :last_name, :string
    add_column :attendances, :organization, :string
  end
end
