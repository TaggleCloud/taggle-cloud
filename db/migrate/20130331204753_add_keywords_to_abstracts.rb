class AddKeywordsToAbstracts < ActiveRecord::Migration
  def change
    add_column :abstracts, :keywords, :boolean, :default => false
    Abstract.all.each do |att|
      att.keywords = false
      att.save
    end
    User.all.each do |usr|
      @keys = Abstract.new(:user_id => usr.id)
      @keys.keywords = true
      @keys.is_bio = false
      @keys.save
    end
  end
end
