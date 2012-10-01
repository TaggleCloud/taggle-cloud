class CreateAbstractTags < ActiveRecord::Migration
  def change
    create_table :abstract_tags do |t|
      t.integer :abstract_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
