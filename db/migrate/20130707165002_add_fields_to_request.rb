class AddFieldsToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :invitee_registered, :boolean
    add_column :requests, :email, :string
    add_column :requests, :body, :string
    add_column :requests, :reply, :string
  end
end
