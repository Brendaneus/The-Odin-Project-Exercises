class CreateScores < ActiveRecord::Migration[6.0]
  def change
    create_table :scores do |t|
      t.references :user, foreign_key: true
      t.references :picture, null: false, foreign_key: true

      t.datetime :last_active
      t.integer :elapsed_time, default: 0
      t.boolean :finished, default: false

      t.timestamps
    end
  end
end
