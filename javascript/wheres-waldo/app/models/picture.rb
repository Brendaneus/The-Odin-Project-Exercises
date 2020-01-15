class Picture < ApplicationRecord
  belongs_to :album, optional: true
  has_many :locations, dependent: :destroy
  has_many :characters, through: :locations
  has_many :scores, dependent: :destroy

  has_one_attached :image

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 32 }

  def get_match character, coords
    if location = locations.find_by(character: character)
      return location if location.contains_coords? coords
    else
      false
    end
  end

end
