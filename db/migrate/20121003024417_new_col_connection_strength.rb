class NewColConnectionStrength < ActiveRecord::Migration
  def up
    add_column :connections, :strength, :integer
  end
end
