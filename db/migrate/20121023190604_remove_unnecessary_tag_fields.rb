class RemoveUnnecessaryTagFields < ActiveRecord::Migration
  def change
    remove_column :tags, :abstract_id
    remove_column :tags, :abstract_tag_id
  end
end
