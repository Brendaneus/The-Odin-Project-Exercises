class CreateAttendedEventsAttendeesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :attended_events, :attendees do |t|
    	t.index :attended_event_id
    	t.index :attendee_id
    end
  end
end
