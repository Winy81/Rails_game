class AddManualyHibernatedToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :manualy_hibernated, :boolean
  end
end
