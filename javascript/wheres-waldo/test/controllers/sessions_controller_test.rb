require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @users = {
      admin: users(:admin),
      one: users(:one),
      two: users(:two)
    }
  end

  test "should get login" do
    get login_path
    assert_response :success
  end

  test "should post login" do
    build_session

    # bad params
    assert_no_changes -> { logged_in? }, from: false do
      post login_path, params: { name: '' }
    end
    assert_response :success

    # success
    assert_changes -> { logged_in_as? @users[:one] }, from: false, to: true do
      post login_path, params: { name: @users[:one].name, password: 'password' }
    end
    assert_response :redirect
  end

  test "should get logout" do
    build_session

    # not logged in
    assert_no_changes -> { logged_in? }, from: false do
      get logout_path
    end
    assert_response :redirect

    # success
    log_in_as @users[:one]
    assert_changes -> { logged_in? }, from: true, to: false do
      get logout_path
    end
    assert_response :redirect
  end

end
