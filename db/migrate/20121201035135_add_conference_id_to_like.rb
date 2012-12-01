class AddConferenceIdToLike < ActiveRecord::Migration
  def change
    add_column :likes, :conference_id, :integer
  end
end
