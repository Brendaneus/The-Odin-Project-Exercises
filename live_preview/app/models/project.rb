class Project < ApplicationRecord

	belongs_to :course

	scope :visible, -> { where(visible: true) }

	validates :name, presence: true,
					 uniqueness: true,
					 length: {maximum: 50}

end
