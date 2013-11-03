class AddConfAdminRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_conf_admin, :boolean
    add_column :users, :conf_left, :int
  end
end
