module ApplicationHelper
	def current_user
		if session_id = session[:user_id]
			@user ||= User.find( session_id )
		end
	end

	def logged_in?
		!current_user.nil?
	end

	def attending? event
		event.attendees.include? current_user
	end

	def hosting? event
		current_user == event.creator
	end

	def inviter_for? invitation
		current_user == invitation.inviter
	end

	def invitee_for? invitation
		current_user == invitation.invitee
	end
end
