class RemoveUnnecessaryTagFields < ActiveRecord::Migration
  def change
    remove_column :tags, :abstract_id
    remove_column :tags, :abstract_tags_id
  end
end
