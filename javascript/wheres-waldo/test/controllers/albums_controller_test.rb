require 'test_helper'

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @albums = {
      one: albums(:one),
      two: albums(:two)
    }

    @users = {
      admin: users(:admin),
      one: users(:one),
      two: users(:two)
    }
  end

  test "get index" do
    get albums_path
    assert_response :success
  end

  test "get show" do
    get album_path(@albums[:one])
    assert_response :success
  end

  test "get new [only admins]" do
    # Guest
    get new_album_url
    assert_response :redirect

    # User
    log_in_as @users[:one]
    get new_album_url
    assert_response :redirect

    # Admin
    log_in_as @users[:admin], password: 'secret'
    get new_album_path
    assert_response :success
  end

  test "post create [only admins]" do
    # Guest
    assert_no_difference 'Album.count' do
      post albums_url( params: { album: { title: 'New Album 1' } } )
    end

    # User
    log_in_as @users[:one]
    assert_no_difference 'Album.count' do
      post albums_url( params: { album: { title: 'New Album 2' } } )
    end

    # Admin, invalid
    log_in_as @users[:admin], password: 'secret'
    assert_no_difference 'Album.count' do
      post albums_path, params: { album: { title: '' } }
    end

    # Admin, valid
    assert_difference 'Album.count', 1 do
      post albums_path, params: { album: { title: 'New Album 3' } }
    end
  end

  test "get edit [only admins]" do
    # Guest
    get edit_album_path(@albums[:one])
    assert_response :redirect
    
    # User
    log_in_as @users[:one]
    get edit_album_path(@albums[:one])
    assert_response :redirect
    
    # Admin
    log_in_as @users[:admin], password: 'secret'
    get edit_album_path(@albums[:one])
    assert_response :success
  end

  test "put/patch update [...for admins only]" do
    # Guest / PUT
    assert_no_changes -> { @albums[:one].title } do
      put album_path(@albums[:one]), params: { album: { title: 'Updated Title 1' } }
      @albums[:one].reload
    end

    # Guest / PATCH
    assert_no_changes -> { @albums[:one].title } do
      patch album_path(@albums[:one]), params: { album: { title: 'Updated Title 2' } }
      @albums[:one].reload
    end

    # User
    log_in_as @users[:one]
    assert_no_changes -> { @albums[:one].title } do
      put album_path(@albums[:one]), params: { album: { title: 'Updated Title 3' } }
      @albums[:one].reload
    end

    # Admin, invalid
    log_in_as @users[:admin], password: 'secret'
    assert_no_changes -> { @albums[:one].title } do
      patch album_path(@albums[:one]), params: { album: { title: '' } }
      @albums[:one].reload
    end

    # Admin, valid
    assert_changes -> { @albums[:one].title } do
      patch album_path(@albums[:one]), params: { album: { title: 'Updated Title 2' } }
      @albums[:one].reload
    end
  end

  test "delete destroy [...for admins only]" do
    # Guest
    assert_no_difference 'Album.count' do
      delete album_path(@albums[:one])
    end

    # User
    log_in_as @users[:one]
    assert_no_difference 'Album.count' do
      delete album_path(@albums[:one])
    end

    # Admin
    log_in_as @users[:admin], password: 'secret'
    assert_difference 'Album.count', -1 do
      delete album_path(@albums[:one])
    end
  end
  
end
