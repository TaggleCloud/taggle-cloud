class AddPreferenceColumnToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :preference_categories, :text
  end
end
