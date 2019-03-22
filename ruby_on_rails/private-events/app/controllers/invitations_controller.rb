class InvitationsController < ApplicationController
	before_action :require_login
	before_action :require_creator, only: [:new, :create]
	before_action :require_invitee_or_inviter_or_creator, only: [:show, :destroy]

	def index
		@invitations = current_user.received_invitations
	end

	def show
		@invitation = Invitation.find( params[:id] )
		@event = @invitation.event
		@inviter = @invitation.inviter
		@invitee = @invitation.invitee
	end

	def new
		@event = Event.find( params[:event_id] )
		@user_choices = User.where( 'id NOT IN ?', @event.attendees.collect { |attendee| attendee.id } )
		@invitation = @event.invitations.new
	end

	def create
		@event = Event.find( params[:event_id] )
		@invitation = @event.invitations.build( invitation_params )
		@invitation.inviter = current_user
		if @invitation.save
			flash[:success] = "You have successfully invited #{@invitation.invitee.name} to #{@event.name}."
			redirect_to event_path( @event )
		else
			flash.now[:failure] = "There was a problem creating your invitation."
			render :new
		end
	end

	def destroy
		@invitation = Invitation.find( params[:id] )
		@invitation.destroy
		flash[:success] = "You have successfully deleted the invitation."
		if request.headers["HTTP_REFERER"] =~ /invitations/
			redirect_to invitations_path
		else
			redirect_back( fallback_location: events_path )
		end
	end

	private

		def invitation_params
			params.require(:invitation).permit(:invitee_id)
		end

		def require_creator
			event = Event.find( params[:event_id] )
			unless hosting? event
				flash[:warning] = "You aren't allowed to do that."
				redirect_to event_path( event )
			end
		end

		def require_invitee_or_inviter_or_creator
			invitation = Invitation.find(params[:id] )
			unless ( invitee_for? invitation ) || ( inviter_for? invitation ) || ( hosting? invitation.event )
				flash[:warning] = "You aren't allowed to do that."
				redirect_to event_path( invitation.event )
			end
		end
end
