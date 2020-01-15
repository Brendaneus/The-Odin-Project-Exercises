class CreateJoinTableScoresLocations < ActiveRecord::Migration[6.0]
  def change
    create_join_table :scores, :locations do |t|
      t.index [:score_id, :location_id]
    end
  end
end
