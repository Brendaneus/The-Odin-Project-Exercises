class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.references :event, index: true
      t.references :inviter, index: true
      t.references :invitee, index: true

      t.timestamps
    end
  end
end
