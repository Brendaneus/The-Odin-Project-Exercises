class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :course, foreign_key: true
      t.string :name
      t.text :notes

      t.string :tutorial
      t.string :source
      t.string :url

      t.boolean :complete, default: true
      t.boolean :visible, default: true

      t.timestamps

      t.string :slug
      t.index :slug, unique: true
    end
  end
end
