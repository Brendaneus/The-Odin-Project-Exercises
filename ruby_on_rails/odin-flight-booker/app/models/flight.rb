class Flight < ApplicationRecord
  belongs_to :origin, class_name: 'Airport',
  					  inverse_of: :departing_flights
  belongs_to :destination, class_name: 'Airport',
  						   inverse_of: :arriving_flights
  has_many :bookings

  validates_presence_of :origin, :destination, :departure, :duration
  validates :duration, numericality: { greater_than_or_equal_to: 30 }
  validate :origin_is_not_destination

  def departure_formatted
    departure.strftime("%m/%d/%Y AT %H:%M%p")
  end

  def departure_date_formatted
  	departure.strftime("%m/%d/%Y")
  end

  # Credit to https://stackoverflow.com/a/1224769
  def duration_in_words
  	minutes = (duration / 60).round
  	hours = minutes / 60
  	minutes = minutes - (hours * 60)

    words = ""
  	words << "#{hours} #{ (hours == 1) ? 'hour' : 'hours' }" if hours > 0
    words << ", " if hours > 0 && minutes > 0
  	words << "#{minutes} #{ (minutes == 1) ? 'minute' : 'minutes' }" if minutes > 0

    words
  end


  private

  	# Validators

  	def origin_is_not_destination
  		if origin == destination
  			errors.add( :destination, "can't be Origin")
  		end
  	end
end
