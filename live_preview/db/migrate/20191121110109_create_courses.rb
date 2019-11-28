class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name

      t.string :source
      t.string :tutorial

      t.boolean :visible, default: true

      t.timestamps

      t.string :slug
      t.index :slug, unique: true
    end
  end
end
