class AddHascharacterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_character, :boolean
  end
end
