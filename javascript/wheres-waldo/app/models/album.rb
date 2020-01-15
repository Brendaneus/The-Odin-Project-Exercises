class Album < ApplicationRecord
  has_many :pictures, dependent: :nullify

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }
end
