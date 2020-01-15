require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @albums = {
      one: albums(:one),
      two: albums(:two)
    }

    @pictures = {
      one: pictures(:one),
      two: pictures(:two),
      three: pictures(:three),
      four: pictures(:four)
    }

    @characters = {
      waldo: characters(:waldo),
      wenda: characters(:wenda),
      odlaw: characters(:odlaw),
      wizard: characters(:wizard),
      woof: characters(:woof)
    }

    # Ordered by pictures, then characters
    @locations = {
      one: {
        waldo: locations(:one_waldo),
        wenda: locations(:one_wenda),
        odlaw: locations(:one_odlaw)
      },
      two: {
        wizard: locations(:two_wizard),
        woof: locations(:two_woof),
      }
    }
  end

  test "all coordinates must be present" do
    @locations[:one][:waldo].left_coord = nil
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].left_coord = 5

    @locations[:one][:waldo].right_coord = nil
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].right_coord = 5

    @locations[:one][:waldo].top_coord = nil
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].top_coord = 5
    
    @locations[:one][:waldo].bottom_coord = nil
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].bottom_coord = 5
  end

  test "all coordinates must be between 0 and 100" do
    @locations[:one][:waldo].right_coord = 100
    @locations[:one][:waldo].left_coord = 0
    assert @locations[:one][:waldo].valid?
    @locations[:one][:waldo].left_coord = -1
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].left_coord = 100
    assert @locations[:one][:waldo].valid?
    @locations[:one][:waldo].left_coord = 101
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].left_coord = 0

    @locations[:one][:waldo].right_coord = 0
    assert @locations[:one][:waldo].valid?
    @locations[:one][:waldo].right_coord = -1
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].right_coord = 100
    assert @locations[:one][:waldo].valid?
    @locations[:one][:waldo].right_coord = 101
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].right_coord = 0

    @locations[:one][:waldo].bottom_coord = 100
    @locations[:one][:waldo].top_coord = 0
    assert @locations[:one][:waldo].valid?
    @locations[:one][:waldo].top_coord = -1
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].top_coord = 100
    assert @locations[:one][:waldo].valid?
    @locations[:one][:waldo].top_coord = 101
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].top_coord = 0

    @locations[:one][:waldo].bottom_coord = 0
    assert @locations[:one][:waldo].valid?
    @locations[:one][:waldo].bottom_coord = -1
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].bottom_coord = 100
    assert @locations[:one][:waldo].valid?
    @locations[:one][:waldo].bottom_coord = 101
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].bottom_coord = 0
  end

  test "left coord must be less than right coord" do
    @locations[:one][:waldo].left_coord = 10
    @locations[:one][:waldo].right_coord = 1
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].right_coord = 10
    assert @locations[:one][:waldo].valid?
  end

  test "top coord must be less than bottom coord" do
    @locations[:one][:waldo].top_coord = 10
    @locations[:one][:waldo].bottom_coord = 1
    assert_not @locations[:one][:waldo].valid?
    @locations[:one][:waldo].bottom_coord = 10
    assert @locations[:one][:waldo].valid?
  end

  test "returns all coordinates with attr_getter" do
    coords = @locations[:one][:waldo].coords
    assert coords == [@locations[:one][:waldo].left_coord, @locations[:one][:waldo].right_coord, @locations[:one][:waldo].top_coord, @locations[:one][:waldo].bottom_coord]
  end

  test "sets all coordinates with attr_setter" do
    coords = [5, 6, 7, 8]
    @locations[:one][:waldo].coords = coords
    assert coords == [@locations[:one][:waldo].left_coord, @locations[:one][:waldo].right_coord, @locations[:one][:waldo].top_coord, @locations[:one][:waldo].bottom_coord]
  end

  test "checks if coordinates contain other coordinate pair" do
    assert @locations[:one][:waldo].contains_coords?([2, 2])
    assert_not @locations[:one][:waldo].contains_coords?([10, 10])
  end
end
