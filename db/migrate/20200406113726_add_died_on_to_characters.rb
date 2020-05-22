class AddDiedOnToCharacters < ActiveRecord::Migration
  def up
    add_column :characters, :died_on, :datetime, default: nil
  end

  def down
    remove_column :characters, :died_on
  end
end
