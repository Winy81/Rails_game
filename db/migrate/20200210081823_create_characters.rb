class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name,                   null: false
      t.string :status,                 null: false,default: "alive"
      t.integer :age,                   null: false,default: 0
      t.string :happiness,              null: false,default: 100
      t.integer :fed_state,             null: false,default: 100
      t.integer :activity_require_level,null: false,default: 0

      t.timestamps null: false
    end
  end
end
