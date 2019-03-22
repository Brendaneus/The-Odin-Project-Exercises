class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :inviter, class_name: "User" # Need class_name for invite references to work
  belongs_to :invitee, class_name: "User" # Would look for the 'Invitee' class otherwise, more than a join table

  scope :for, -> (event) { where ["event = ?", event] }

	validates_presence_of :event
	validates_presence_of :inviter
	validates_presence_of :invitee
	validate :inviter_is_not_invitee
	validate :invitee_is_not_attending
	validate :invitee_is_not_invited

	private

		def inviter_is_not_invitee
			if ( inviter == invitee )
				errors.add(:invitee, "is you!  Attend this event yourself on the event page.")
			end
		end

		def invitee_is_not_attending
			if ( event.attendees.include? invitee )
				errors.add(:invitee, "is already attending this event.")
			end
		end

		def invitee_is_not_invited
			if ( invitee.received_invitations.collect{ |invitation| invitation.event }.include? event )
				errors.add(:invitee, "has already been invited to this event.")
			end
		end
end
