
class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.references :picture, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
      
      t.float :left_coord
      t.float :right_coord
      t.float :top_coord
      t.float :bottom_coord

      t.string :hint
    end
  end
end
