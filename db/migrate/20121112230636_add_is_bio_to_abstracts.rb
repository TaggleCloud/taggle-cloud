class AddIsBioToAbstracts < ActiveRecord::Migration
  def change
    add_column :abstracts, :is_bio, :boolean, :default => false
  end

  def up
    User.all.each do |usr|
      @bio = Abstract.new(:user_id => usr.id)
      @bio.is_bio = true
      @bio.save
    end
    Abstract.all.each do |att|
      att.is_bio = false
      att.save
    end
  end
end
