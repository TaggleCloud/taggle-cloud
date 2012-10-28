class SplitUserNameIntoFirstAndLastName < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    User.all.each do |user|
      split_name = user.name.split(' ')
      user.first_name = split_name[0]
      l_name = ""
      for index in 1 ... split_name.size
        l_name += split_name[index] + " "
      end
      user.last_name = l_name[0..-2]
    end
    remove_column :users, :name
  end

  def down
    add_column :users, :name, :string
    User.all.each do |user|
      user.name = user.first_name + " " + user.last_name
    end
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
