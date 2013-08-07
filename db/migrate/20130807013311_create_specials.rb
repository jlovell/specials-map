class CreateSpecials < ActiveRecord::Migration
  def change
    create_table :specials do |t|
      t.integer :day
      t.string :food
      t.string :drink
      t.string :event
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
