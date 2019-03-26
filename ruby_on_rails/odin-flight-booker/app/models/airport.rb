class Airport < ApplicationRecord
	has_many :departing_flights, class_name: 'Flight',
								 foreign_key: :origin_id,
								 inverse_of: :origin
	has_many :arriving_flights, class_name: 'Flight',
								foreign_key: :destination_id,
								inverse_of: :destination 

	validates :code, presence: true,
					 uniqueness: true,
					 length: { is: 3 }
end
