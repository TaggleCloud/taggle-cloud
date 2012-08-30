class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :location

      t.timestamps
    end
  end
end
