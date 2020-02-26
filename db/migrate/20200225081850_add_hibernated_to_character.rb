class AddHibernatedToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :hibernated, :boolean
  end
end
