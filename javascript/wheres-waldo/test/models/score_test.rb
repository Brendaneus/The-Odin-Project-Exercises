require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  setup do
    @users = {
      admin: users(:admin),
      one: users(:one),
      two: users(:two)
    }

    @pictures = {
      one: pictures(:one),
      two: pictures(:two),
      three: pictures(:three),
      four: pictures(:four)
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
      },
      guest: {
        one: scores(:guest_one),
        two: scores(:guest_two)
      }
    }
  end

  test "should check if owned" do
    assert @scores[:one][:one].owned?

    assert_not @scores[:guest][:one].owned?
  end

  test "should check if active" do
    @scores[:one][:one].last_active = nil
    assert_not @scores[:one][:one].active?

    @scores[:one][:one].last_active = 10.minutes.ago
    assert @scores[:one][:one].active?
  end

  test "should get total time elapsed" do
    @scores[:one][:one].last_active = nil
    assert @scores[:one][:one].total_time == @scores[:one][:one].elapsed_time

    @scores[:one][:one].last_active = 5.seconds.ago
    assert @scores[:one][:one].total_time ==
      (@scores[:one][:one].elapsed_time + (DateTime.now.getutc - @scores[:one][:one].last_active)).to_i
  end

  test "should update time if time has elapsed (reactivate)" do
    # Inactive
    @scores[:one][:one].last_active = nil
    assert_changes -> { @scores[:one][:one].last_active } do
      assert_no_changes -> { @scores[:one][:one].elapsed_time } do
        @scores[:one][:one].update_time
      end
    end

    # Active
    @scores[:one][:one].last_active = 5.minutes.ago
    assert_changes -> { @scores[:one][:one].last_active } do
      assert_changes -> { @scores[:one][:one].elapsed_time } do
        @scores[:one][:one].update_time
      end
    end
  end

  test "should add time if time has elapsed (deactivate)" do
    # Inactive
    assert_no_changes -> { @scores[:one][:one].last_active } do
      assert_no_changes -> { @scores[:one][:one].elapsed_time } do
        @scores[:one][:one].add_time
      end
    end

    # Active
    @scores[:one][:one].last_active = 5.minutes.ago
    assert_changes -> { @scores[:one][:one].last_active }, to: nil do
      assert_changes -> { @scores[:one][:one].elapsed_time } do
        @scores[:one][:one].add_time
      end
    end
  end

  test "should finish if possible" do
    @scores[:one][:one].locations.clear
    assert_no_changes -> { @scores[:one][:one].finished? }, from: false do
      @scores[:one][:one].finish
      @scores[:one][:one].reload
    end

    @scores[:one][:one].locations << @pictures[:one].locations
    assert_changes -> { @scores[:one][:one].finished? }, from: false, to: true do
      @scores[:one][:one].finish
      @scores[:one][:one].reload
    end
  end

  test "should scope finished" do
    assert Score.finished == Score.where(finished: true)
  end

  test "should scope unfinished" do
    assert Score.unfinished == Score.where(finished: false)
  end

end
