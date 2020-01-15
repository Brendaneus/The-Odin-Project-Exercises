require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @users = {
      admin: users(:admin),
      one: users(:one),
      two: users(:two)
    }

    # Ordered by users, then pictures
    @scores = {
      admin: {
        one: scores(:admin_one),
        two: scores(:admin_two)
      },
      one: {
        one: scores(:one_one),
        two: scores(:one_two)
      },
      two: {
        one: scores(:two_one),
        two: scores(:two_two)
      }
    }
  end

  test "name must be present" do
    @users[:one].name = ''
    assert_not @users[:one].valid?
    @users[:one].name = '    '
    assert_not @users[:one].valid?
  end

  test "name must be unique (case-insensitive)" do
    @users[:one].name = @users[:two].name.upcase
    assert_not @users[:one].valid?
    @users[:one].name = @users[:two].name.downcase
    assert_not @users[:one].valid?
  end

  test "password and confirmation must both be present or missing" do
    # Both missing
    @users[:one].password = ''
    @users[:one].password_confirmation = ''
    assert @users[:one].valid?
    # Only password present
    @users[:one].password = 'new_password'
    assert_not @users[:one].valid?
    # Both present
    @users[:one].password_confirmation = 'new_password'
    assert @users[:one].valid?
    # Only password_confirmation present
    @users[:one].password = nil
    assert_not @users[:one].valid?
  end

  test "authenticates passwords" do
    assert @users[:one].authenticates?(:password, 'password')
    assert_not @users[:one].authenticates?(:password, 'invalid')
  end

  test "scores must be dependent destroyed" do
    @users[:one].destroy

    @scores[:one].each_value do |score|
      assert_raise (ActiveRecord::RecordNotFound) { score.reload }
    end
  end
end
