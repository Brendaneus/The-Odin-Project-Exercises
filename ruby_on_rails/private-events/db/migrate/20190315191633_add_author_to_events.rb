class AddAuthorToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :creator, index: true
  end
end
