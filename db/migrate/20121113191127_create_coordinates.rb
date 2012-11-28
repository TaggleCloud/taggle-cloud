class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.integer :user_id
      t.integer :conference_id

      t.timestamps
    end
  end
end
