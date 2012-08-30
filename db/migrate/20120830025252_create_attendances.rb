class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :conference_id
      t.string :registered_email

      t.timestamps
    end
  end
end
