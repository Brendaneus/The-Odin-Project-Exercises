class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :course, foreign_key: true
      t.string :name
      t.text :notes

      t.string :tutorial
      t.string :url
      t.string :source

      t.boolean :visible, default: true

      t.timestamps
    end
  end
end
