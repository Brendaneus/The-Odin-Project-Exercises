class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name

      t.string :tutorial

      t.boolean :visible, default: true

      t.timestamps
    end
  end
end
