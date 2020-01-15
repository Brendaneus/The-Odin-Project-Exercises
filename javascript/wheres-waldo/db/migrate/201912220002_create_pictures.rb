class CreatePictures < ActiveRecord::Migration[6.0]
  def change
    create_table :pictures do |t|
      t.references :album, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
