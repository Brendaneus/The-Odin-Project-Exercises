class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :course, foreign_key: true
      t.string :name
      t.string :url
      t.text :notes

      t.timestamps
    end
  end
end
