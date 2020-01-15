require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @users = {
      admin: users(:admin),
      one: users(:one),
      two: users(:two),
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

  test "should get show [only authorized and admins]" do
    # Guest
    get user_path(@users[:one])
    assert_response :redirect

    # User, unauthorized
    log_in_as @users[:one]
    get user_path(@users[:two])
    assert_response :redirect

    # User, authorized
    get user_path(@users[:one])
    assert_response :success

    # Admin
    log_in_as @users[:admin], password: 'secret'
    get user_path(@users[:one])
    assert_response :success
  end

  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should post create" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '' } }
    end
    assert_response :success
    assert_not logged_in?

    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "test", password: "password", password_confirmation: "password" } }
    end
    assert_response :redirect
    assert logged_in?
  end

  test "should get edit [only admins and authorized]" do
    # Guest
    get edit_user_path(@users[:one])
    assert_response :redirect

    # User, unauthorized
    log_in_as @users[:one]
    get edit_user_path(@users[:two])
    assert_response :redirect

    # User, authorized
    get edit_user_path(@users[:one])
    assert_response :success

    # Admin
    log_in_as @users[:admin], password: 'secret'
    get edit_user_path(@users[:one])
    assert_response :success
  end

  test "should put/patch update [only admins and authorized]" do
    # Guest / PUT
    assert_no_changes -> { @users[:one].name } do
      put user_path(@users[:one]), params: { user: { name: 'Updated Name 1' } }
      @users[:one].reload
    end
    assert_response :redirect

    # Guest / PATCH
    assert_no_changes -> { @users[:one].name } do
      patch user_path(@users[:one]), params: { user: { name: 'Updated Name 2' } }
      @users[:one].reload
    end
    assert_response :redirect


    # User, unauthorized
    log_in_as @users[:one]
    assert_no_changes -> { @users[:two].name } do
      put user_path(@users[:two]), params: { user: { name: 'Updated Name 3' } }
      @users[:two].reload
    end
    assert_response :redirect

    # User, authorized / invalid
    assert_no_changes -> { @users[:one].name } do
      put user_path(@users[:one]), params: { user: { name: '' } }
      @users[:one].reload
    end
    assert_response :success

    # User, authorized / valid
    assert_changes -> { @users[:one].name } do
      put user_path(@users[:one]), params: { user: { name: 'Updated Name 4' } }
      @users[:one].reload
    end
    assert_response :redirect


    # Admin
    log_in_as @users[:admin], password: 'secret'
    assert_changes -> { @users[:one].name } do
      put user_path(@users[:one]), params: { user: { name: 'Updated Name 5' } }
      @users[:one].reload
    end
    assert_response :redirect
  end

  test "should delete destroy [...for admins and authorized only]" do
    # Guest
    assert_no_difference 'User.count' do
      delete user_path(@users[:one])
    end

    # User, unauthorized
    log_in_as @users[:one]
    assert_no_difference 'User.count' do
      delete user_path(@users[:two])
    end

    # User, authorized
    assert_difference 'User.count', -1 do
      delete user_path(@users[:one])
    end

    # Admin
    log_in_as @users[:admin], password: 'secret'
    assert_difference 'User.count', -1 do
      delete user_path(@users[:two])
    end
  end
end
