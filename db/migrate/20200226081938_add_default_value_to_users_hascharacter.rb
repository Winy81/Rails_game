class AddDefaultValueToUsersHascharacter < ActiveRecord::Migration
  def up
    change_column :users, :has_character, :boolean, default: false
  end

  def down
    change_column :users, :has_character, :boolean, default: nil
  end
end
