class Course < ApplicationRecord

	has_many :projects, dependent: :destroy

	scope :visible, -> { where(visible: true) }

	validates :name, presence: true,
					 uniqueness: true,
					 length: {maximum: 50}

	def complete?
		if projects.empty?
			false
		else
			projects.all? { |project| project.complete? }
		end
	end

end
