require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  def setup
    @albums = {
      one: albums(:one),
      two: albums(:two)
    }

    @pictures = {
      one: {
        one: pictures(:one),
        two: pictures(:two)
      },
      two: {
        one: pictures(:three),
        two: pictures(:four)
      }
    }
  end

  test "title must be present" do
    @albums[:one].title = ''
    assert_not @albums[:one].valid?
    @albums[:one].title = '   '
    assert_not @albums[:one].valid?
  end

  test "title must be unique (case-insensitive)" do
    @albums[:one].title = @albums[:two].title.upcase
    assert_not @albums[:one].valid?
    @albums[:one].title = @albums[:two].title.downcase
    assert_not @albums[:one].valid?
  end

  test "pictures must not be dependent destroyed" do
    @albums[:one].destroy

    @pictures[:one].each_value do |value|
      assert_nothing_raised { value.reload }
    end
  end
end
