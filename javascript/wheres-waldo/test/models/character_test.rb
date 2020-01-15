require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  def setup
    @characters = {
      waldo: characters(:waldo),
      wenda: characters(:wenda),
      odlaw: characters(:odlaw),
      wizard: characters(:wizard),
      woof: characters(:woof)
    }

    # Ordered by characters, then pictures
    @locations = {
      waldo: {
        one: locations(:one_waldo)
      },
      wenda: {
        one: locations(:one_wenda)
      },
      odlaw: {
        one: locations(:one_odlaw)
      },
      wizard: {
        two: locations(:two_wizard)
      },
      woof: {
        two: locations(:two_woof)
      }
    }
  end

  test "name must be present" do
    @characters[:waldo].name = ''
    assert_not @characters[:waldo].valid?
    @characters[:waldo].name = '   '
    assert_not @characters[:waldo].valid?
  end

  test "name must be unique (case-insensitive)" do
    @characters[:waldo].name = @characters[:wenda].name.upcase
    assert_not @characters[:waldo].valid?
    @characters[:waldo].name = @characters[:wenda].name.downcase
    assert_not @characters[:waldo].valid?
  end

  test "locations must be dependent destroyed" do
    @characters[:waldo].destroy

    @locations[:waldo].each_value do |location|
      assert_raise (ActiveRecord::RecordNotFound) { location.reload }
    end
  end
end
