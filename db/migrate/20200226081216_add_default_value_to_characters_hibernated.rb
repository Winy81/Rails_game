class AddDefaultValueToCharactersHibernated < ActiveRecord::Migration
  def up
    change_column :characters, :hibernated, :boolean, default: false
    change_column :characters, :manualy_hibernated, :boolean, default: false
  end

  def down
    change_column :characters, :hibernated, :boolean, default: nil
    change_column :characters, :manualy_hibernated, :boolean, default: nil
  end
end
