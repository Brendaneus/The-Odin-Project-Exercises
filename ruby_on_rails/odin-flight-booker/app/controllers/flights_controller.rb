class FlightsController < ApplicationController
	include FlightsHelper
	before_action :ensure_different_airports

	def index
		@airport_options = Airport.all.map { |airport| [airport.code, airport.id] }
		@flight_time_options = Flight.order(:departure).map { |flight| [flight.departure_date_formatted, flight.departure.to_date] }.uniq

		if search_params_present?
			@flights = Flight.all.includes(:origin, :destination)
			@flights = @flights.where( origin_id: params[:origin] ) if params[:origin].present?
			@flights = @flights.where( destination_id: params[:destination] ) if params[:destination].present?
			@flights = @flights.where( 'departure BETWEEN ? AND ?', params[:departure].to_datetime, ( params[:departure].to_datetime + 1.day ) ) if params[:departure].present?
		end
	end


	private

		def ensure_different_airports
			if params[:origin].present? && ( params[:origin] == params[:destination] )
				flash.now[:error] = "There are no flights departing from and arriving at same airport."
			end
		end
end
