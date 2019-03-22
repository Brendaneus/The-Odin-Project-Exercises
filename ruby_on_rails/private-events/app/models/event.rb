class Event < ApplicationRecord
	belongs_to :creator, class_name: "User"
	
	has_many :invitations

	# Thanks @alexcorremans!  This method requires no join model, check the schema
	has_and_belongs_to_many :attendees, # Association Name
		class_name: "User", # Other model's class name, defaults like 'Attendees'
		join_table: :attended_events_attendees, # Join table, must be alphabetized, would be like 'attendees_events' by default
		foreign_key: :attended_event_id, # Name of the column this model's id should be found in, defaults to this class name
		association_foreign_key: :attendee_id # Name of the column the associated model's key should be taken from, defaults like 'user_id' in this case

	scope :previous, -> { where ["date < ?", DateTime.now] }
	scope :upcoming, -> { where ["date > ?", DateTime.now] }

	validates :name, presence: true, length: { maximum: 64 }
	validates_presence_of :date

	def hosted?
		attendees.include? creator
	end
end
