class Course < ApplicationRecord

	has_many :projects, dependent: :destroy

	validates :name, presence: true,
					 uniqueness: true,
					 length: {maximum: 50}

end
