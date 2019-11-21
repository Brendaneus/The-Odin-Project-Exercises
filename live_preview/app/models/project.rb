class Project < ApplicationRecord

	belongs_to :course

	validates :name, presence: true,
					 uniqueness: true,
					 length: {maximum: 50}

end
