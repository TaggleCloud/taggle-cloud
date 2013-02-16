class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :category
      t.string :content

      t.timestamps
    end
  end
end
