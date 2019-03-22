class AttendancesController < ApplicationController
	before_action :require_login
	before_action :require_authenticate_or_creator

	def create
		event = Event.find(params[:event_id])
		user = User.find(params[:user_id])
		if event.attendees.include? user
			flash[:error] = "#{ ( user == current_user ) ? "You are" : "#{ user.name } is" } already attending this event."
			redirect_to event_path( event )
		else
			event.attendees << user
			flash[:success] = "#{ ( user == current_user ) ? "You are" : "#{ user.name } is" } now attending this event."
			redirect_to event_path( event )
		end
	end

	def destroy
		event = Event.find(params[:event_id])
		user = User.find(params[:user_id])
		if !event.attendees.include? user
			flash[:success] = "#{ ( user == current_user ) ? "You aren't" : "#{ user.name } isn't" } attending this event."
			redirect_to event_path( event )
		else
			event.attendees.delete user
			flash[:error] = "#{ ( user == current_user ) ? "You are" : "#{ user.name } is" } no longer attending this event."
			redirect_to event_path( event )
		end
	end

	private

		def require_authenticate_or_creator
			event = Event.find( params[:event_id] )
			unless ( current_user == User.find( params[:user_id] ) ) || ( hosting? event )
				flash[:warning] = "You aren't allowed to do that."
				redirect_to event_path( event )
			end
		end
end
