class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :authentication_id
      t.integer :user_id
      t.string :uid
      t.string :provider
      t.timestamps
    end
  end
end
