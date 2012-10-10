class RemoveConferenceIdFromConnection < ActiveRecord::Migration
  def change
    remove_column :connections, :conference_id
  end
end
