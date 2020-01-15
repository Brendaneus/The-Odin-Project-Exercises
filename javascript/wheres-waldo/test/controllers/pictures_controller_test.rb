require 'test_helper'

class PicturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @albums = {
      one: albums(:one),
      two: albums(:two)
    }

    # Ordered by albums
    @pictures = {
      one: {
        one: pictures(:one),
        two: pictures(:two)
      },
      two: {
        three: pictures(:three),
        four: pictures(:four)
      }
    }

    @characters = {
      waldo: characters(:waldo),
      wenda: characters(:wenda),
      odlaw: characters(:odlaw),
      wizard: characters(:wizard),
      woof: characters(:woof)
    }

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
      },
      guest: {
        one: scores(:guest_one),
        two: scores(:guest_two)
      }
    }
  end

  test "get show [only authorized with score]" do
    # Score unset
    get album_picture_path(@albums[:one], @pictures[:one][:one])
    assert_response :redirect

    # Score set, wrong picture
    log_in_as @users[:one]
    set_score_as @scores[:one][:two]
    get album_picture_path(@albums[:one], @pictures[:one][:one])
    assert_response :redirect

    # Score set, correct picture
    set_score_as @scores[:one][:one]
    get album_picture_path(@albums[:one], @pictures[:one][:one])
    assert_response :success
  end

  test "get available [only admins]" do
    formatted_results = []
    @characters.values.each do |character|
      formatted_results << {
        'id' => character.id,
        'name' => character.name,
        'avatar_url' => avatar_url_for(character),
        'available' => @pictures[:one][:one].locations.none? { |location| location.character_id == character.id }
      }
    end

    # Guest
    get album_picture_selections_path(@albums[:one], @pictures[:one][:one])
    assert_response :redirect
    
    # User
    log_in_as @users[:one]
    get album_picture_selections_path(@albums[:one], @pictures[:one][:one])
    assert_response :redirect

    # Admin
    log_in_as @users[:admin], password: 'secret'
    get album_picture_selections_path(@albums[:one], @pictures[:one][:one])
    
    assert ActiveSupport::JSON.decode(@response.body).sort_by { |character| character['id'] } ==
      ActiveSupport::JSON.decode(formatted_results.to_json).sort_by { |character| character['id'] }
  end

  test "get new [only admins]" do
    # Guest
    get new_album_picture_path(@albums[:one])
    assert_response :redirect

    # One
    log_in_as @users[:one]
    get new_album_picture_path(@albums[:one])
    assert_response :redirect

    # Admin
    log_in_as @users[:admin], password: 'secret'
    get new_album_picture_path(@albums[:one])
    assert_response :success
  end

  test "post create [only admins]" do
    # Guest
    assert_no_difference 'Picture.count' do
      post album_pictures_path(@albums[:one]),
        params: { picture: { title: 'New Picture 1' } }
    end

    # User
    log_in_as @users[:one]
    assert_no_difference 'Picture.count' do
      post album_pictures_path(@albums[:one]),
        params: { picture: { title: 'New Picture 2' } }
    end

    # Admin, invalid
    log_in_as @users[:admin], password: 'secret'
    assert_no_difference 'Picture.count' do
      post album_pictures_path(@albums[:one]),
        params: { picture: { title: '' } }
    end

    # Admin, valid
    assert_difference 'Picture.count', 1 do
      post album_pictures_path(@albums[:one]),
        params: { picture: { title: 'New Picture 3' } }
    end
  end

  test "get edit [only admins]" do
    # Guest
    get edit_album_picture_path(@albums[:one], @pictures[:one][:one])
    assert_response :redirect

    # User
    log_in_as @users[:one]
    get edit_album_picture_path(@albums[:one], @pictures[:one][:one])
    assert_response :redirect

    # Admin
    log_in_as @users[:admin], password: 'secret'
    get edit_album_picture_path(@albums[:one], @pictures[:one][:one])
    assert_response :success
  end

  test "put/patch update [only admins]" do
    # Guest / PUT
    assert_no_changes -> { @pictures[:one][:one].title } do
      put album_picture_path(@albums[:one], @pictures[:one][:one]),
        params: { picture: { title: 'Updated Title 1' } }
      @pictures[:one][:one].reload
    end

    # Guest / PATCH
    assert_no_changes -> { @pictures[:one][:one].title } do
      patch album_picture_path(@albums[:one], @pictures[:one][:one]),
        params: { picture: { title: 'Updated Title 2' } }
      @pictures[:one][:one].reload
    end

    # User
    log_in_as @users[:one]
    assert_no_changes -> { @pictures[:one][:one].title } do
      put album_picture_path(@albums[:one], @pictures[:one][:one]),
        params: { picture: { title: 'Updated Title 3' } }
      @pictures[:one][:one].reload
    end

    # Admin, invalid
    log_in_as @users[:admin], password: 'secret'
    assert_no_changes -> { @pictures[:one][:one].title } do
      put album_picture_path(@albums[:one], @pictures[:one][:one]),
        params: { picture: { title: '' } }
      @pictures[:one][:one].reload
    end

    # Admin, valid
    assert_changes -> { @pictures[:one][:one].title } do
      put album_picture_path(@albums[:one], @pictures[:one][:one]),
        params: { picture: { title: 'Update Title 4' } }
      @pictures[:one][:one].reload
    end
  end

  test "delete destroy [only admins]" do
    # Guest
    assert_no_difference 'Picture.count' do
      delete album_picture_path(@albums[:one], @pictures[:one][:one])
    end

    # User
    log_in_as @users[:one]
    assert_no_difference 'Picture.count' do
      delete album_picture_path(@albums[:one], @pictures[:one][:one])
    end

    # Admin
    log_in_as @users[:admin], password: 'secret'
    assert_difference 'Picture.count', -1 do
      delete album_picture_path(@albums[:one], @pictures[:one][:one])
    end
  end
end
