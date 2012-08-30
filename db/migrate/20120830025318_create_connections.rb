class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :user1_id
      t.integer :user2_id
      t.integer :conference_id

      t.timestamps
    end
  end
end
