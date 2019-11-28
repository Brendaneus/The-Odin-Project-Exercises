# Clear DB for reseeding
unless Rails.env.production?
	Airport.delete_all
	Flight.delete_all
	Booking.delete_all
end

# AIRPORTS
puts "--> SEEDING AIRPORTS"
airport_codes = %w{SFO NYC}# ATL PEK DXB LAX HND ORD LHR HKG PVG CDG AMS DEL CAN FRA DFW}
airport_codes.each do |code|
	Airport.create!( code: code )
end

# FLIGHTS
puts "--> SEEDING FLIGHTS"
Airport.all.each do |origin|
	20.times do
		Airport.where.not( code: origin.code ).each do |destination|
			date_offset = rand(1...240) * 30
			date = DateTime.now.beginning_of_hour.advance( minutes: date_offset )
			duration = rand(3...9) * 1800
			Flight.create!( origin: origin, destination: destination, departure: date, duration: duration )
		end
	end
end