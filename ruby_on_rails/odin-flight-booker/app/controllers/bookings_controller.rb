class BookingsController < ApplicationController
	before_action :ensure_search_params_present, only: :new

	def show
		@booking = Booking.includes(:passengers, flight: [:origin, :destination]).find(params[:id])
	end

	def new
		@flight = Flight.includes(:origin, :destination).find(params[:flight_id])
		@booking = @flight.bookings.build
		@passenger_count ||= params[:passengers].to_i
		@passenger_count.times { @booking.passengers.build }
	end

	def create
		@booking = Booking.new(booking_params)
		@flight = @booking.flight
		@passenger_count = @booking.passengers.count
		if @booking.save
			flash[:success] = "Booking Created!"
			redirect_to booking_path @booking
		else
			flash.now[:failure] = "There was a problem booking your flight."
			render :new
		end
	end


	private

		def booking_params
			params.require(:booking).permit(:flight_id, passengers_attributes: [:id, :name, :email])
		end

		def ensure_search_params_present
			unless params[:flight_id].present? && ( params[:passengers].to_i > 0 )
				flash[:errorA] = "Please choose a flight first." if params[:flight_id].blank?
				flash[:errorB] = "Please search the number of passengers first." unless params[:passengers].to_i > 0
				redirect_back( fallback_location: root_path )
			end
		end
end
