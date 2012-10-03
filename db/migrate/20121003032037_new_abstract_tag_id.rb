class NewAbstractTagId < ActiveRecord::Migration
  def up
    add_column :tags, :abstract_tag_id, :integer
  end
end
