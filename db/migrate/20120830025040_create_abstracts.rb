class CreateAbstracts < ActiveRecord::Migration
  def change
    create_table :abstracts do |t|
      t.integer :user_id
      t.integer :conference_id
      t.text :body

      t.timestamps
    end
  end
end
