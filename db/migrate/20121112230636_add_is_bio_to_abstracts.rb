class AddIsBioToAbstracts < ActiveRecord::Migration
  def change
    add_column :abstracts, :is_bio, :boolean
  end
  
  def up
    User.all.each do |user|
      bio = Abstract.create(:user_id => user.id, :is_bio => true)
    end
  end
end
