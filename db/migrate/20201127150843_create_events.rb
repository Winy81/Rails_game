class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_id,               null: false
      t.string :event_name,              null: false
      t.string :description,             null: false

      t.timestamps null: false
    end
  end
end
