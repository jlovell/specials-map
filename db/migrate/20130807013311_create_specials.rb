class CreateSpecials < ActiveRecord::Migration
  def change
    create_table :specials do |t|
      t.integer :day
      t.text :food
      t.text :drink
      t.text :event
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
