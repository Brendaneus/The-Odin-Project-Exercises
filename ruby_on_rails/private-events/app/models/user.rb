class User < ApplicationRecord
	has_many :created_events, class_name: "Event", foreign_key: :creator_id
	
	has_many :created_invitations, class_name: "Invitation", foreign_key: :inviter_id
	has_many :received_invitations, class_name: "Invitation", foreign_key: :invitee_id

	# Thanks @alexcorremans!  This method requires no join model, check the schema
	has_and_belongs_to_many :attended_events, # Association Name
		class_name: "Event", # Other model's class name, defaults like 'AttendedEvents'
		join_table: :attended_events_attendees, # Join table, must be alphabetized, would be like 'attended_events_users' by default
		foreign_key: :attendee_id, # Name of the column this model's id should be found in, defaults to this class name
		association_foreign_key: :attended_event_id # Name of the column the associated model's key should be taken from, defaults like 'event_id' in this case

	validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 32 }

	def previous_events
		attended_events.where ["date < ?", DateTime.now]
	end

	def upcoming_events
		attended_events.where ["date > ?", DateTime.now]
	end

	def all_events
		(created_events + attended_events).uniq
	end
end
