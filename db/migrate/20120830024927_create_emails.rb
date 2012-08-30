class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :user_id
      t.string :mail_address

      t.timestamps
    end
  end
end
