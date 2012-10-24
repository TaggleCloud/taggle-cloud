class AddImageLocationOccupationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :string
    add_column :users, :location, :string
    add_column :users, :occupation, :string
  end
end
