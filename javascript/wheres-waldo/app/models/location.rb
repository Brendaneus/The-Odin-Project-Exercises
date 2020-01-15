class Location < ApplicationRecord
  belongs_to :picture
  belongs_to :character
  has_and_belongs_to_many :scores

  attr_accessor :coords

  validates :left_coord,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100
    }
  validates :right_coord,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100
    }
  validates :top_coord,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100
    }
  validates :bottom_coord,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100
    }
  validate :right_coord_greater_than_or_equal_to_left_coord
  validate :bottom_coord_greater_than_or_equal_to_top_coord

  def coords
    [left_coord, right_coord, top_coord, bottom_coord]
  end

  def coords=(array)
    update(left_coord: array[0], right_coord: array[1], top_coord: array[2], bottom_coord: array[3])
  end

  def contains_coords? coord_pair
    (coord_pair[0] >= left_coord) &&
    (coord_pair[0] <= right_coord) &&
    (coord_pair[1] >= top_coord) &&
    (coord_pair[1] <= bottom_coord)
  end


  private

    def right_coord_greater_than_or_equal_to_left_coord
      if (left_coord && right_coord) && (left_coord > right_coord)
        errors.add(:right_coord, 'should be at or right of left coord')
      end
    end

    def bottom_coord_greater_than_or_equal_to_top_coord
      if (top_coord && bottom_coord) && (top_coord > bottom_coord)
        errors.add(:bottom_coord, 'should be at or below top coord')
      end
    end

end
