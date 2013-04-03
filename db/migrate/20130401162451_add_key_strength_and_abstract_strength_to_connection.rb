class AddKeyStrengthAndAbstractStrengthToConnection < ActiveRecord::Migration
  def change
    add_column :connections, :keyword_strength, :integer
    add_column :connections, :abstract_strength, :integer
  end
end
