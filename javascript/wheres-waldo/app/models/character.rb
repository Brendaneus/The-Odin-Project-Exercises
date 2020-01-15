class Character < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :pictures, through: :locations

  has_one_attached :avatar

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { maximum: 24 }

end
