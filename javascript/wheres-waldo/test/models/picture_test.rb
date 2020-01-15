require 'test_helper'

class PictureTest < ActiveSupport::TestCase
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

    # Ordered by pictures, then users
    @scores = {
      one: {
        admin: scores(:admin_one),
        one: scores(:one_one),
        two: scores(:two_one)
      },
      two: {
        admin: scores(:admin_two),
        one: scores(:one_two),
        two: scores(:two_two)
      }
    }
  end

  test "title must be present" do
    @pictures[:one].title = ''
    assert_not @pictures[:one].valid?
    @pictures[:one].title = '   '
    assert_not @pictures[:one].valid?
  end

  test "title must be unique (case-insensitive)" do
    @pictures[:one].title = @pictures[:two].title.upcase
    assert_not @pictures[:one].valid?
    @pictures[:one].title = @pictures[:two].title.downcase
    assert_not @pictures[:one].valid?
  end

  test "title length must not exceed 32 chars" do
    @pictures[:one].title = "X" * 32
    assert @pictures[:one].valid?
    @pictures[:one].title = "X" * 33
    assert_not @pictures[:one].valid?
  end

  test "should check if character location matches coords" do
    assert @pictures[:one].get_match(@characters[:waldo], [2, 2]) == @locations[:one][:waldo]
    assert_not @pictures[:one].get_match(@characters[:waldo], [10, 10])
    assert_not @pictures[:two].get_match(@characters[:three], [5, 5])
  end

  test "locations must be dependent destroyed" do
    @pictures[:one].destroy
    
    @locations[:one].each_value do |location|
      assert_raise (ActiveRecord::RecordNotFound) { location.reload }
    end
  end

  test "scores must be dependent destroyed" do
    @pictures[:one].destroy

    @scores[:one].each_value do |score|
      assert_raise (ActiveRecord::RecordNotFound) { score.reload }
    end
  end
end
