class EventsController < ApplicationController
	before_action :require_login, only: [:new, :create]

	def index
		@events = Event.all
		@upcoming_events = Event.upcoming
		@previous_events = Event.previous
	end

	def show
		@event = Event.find(params[:id])
		@invitations = current_user.created_invitations if logged_in? && ( hosting? @event )
	end

	def new
		@event = current_user.created_events.build
	end

	def create
		@event = current_user.created_events.build(event_params)
		if @event.save
			flash[:success] = "Event successfully created!"
			redirect_to event_path( @event )
		else
			flash[:failure] = "There was a problem creating this event."
			render :new
		end
	end


	private
	
		def event_params
			params.require(:event).permit(:name, :description, :date)
		end
end
