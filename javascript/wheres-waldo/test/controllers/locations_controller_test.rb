require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest

  setup do
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

    @users = {
      admin: users(:admin),
      one: users(:one),
      two: users(:two),
    }
  end

  test "[json] get index [only admins]" do
    # Guest
    get album_picture_locations_path(@albums[:one], @pictures[:one])
    assert_response :redirect

    # User
    log_in_as @users[:one]
    get album_picture_locations_path(@albums[:one], @pictures[:one])
    assert_response :redirect

    # Admin, html
    log_in_as @users[:admin], password: 'secret'
    get album_picture_locations_path(@albums[:one], @pictures[:one])
    assert_response :success

    # Admin, json
    get album_picture_locations_path(@albums[:one], @pictures[:one]),
      as: :json
    assert_response :success
    assert ActiveSupport::JSON.decode(@response.body) ==
      ActiveSupport::JSON.decode(@pictures[:one].locations.to_json)
  end

  # TODO: json response content
  test "json post create [only admins]" do
    # Guest
    assert_no_difference 'Location.count' do
      post album_picture_locations_path(@albums[:one], @pictures[:one]),
        params: { location: { character_id: @characters[:waldo].id, left_coord: 10, right_coord: 20, top_coord: 10, bottom_coord: 20 } }, as: :json
    end
    assert_response :redirect

    # User
    log_in_as @users[:one]
    assert_no_difference 'Location.count' do
      post album_picture_locations_path(@albums[:one], @pictures[:one]),
        params: { location: { character_id: @characters[:waldo].id, left_coord: 10, right_coord: 20, top_coord: 10, bottom_coord: 20 } }, as: :json
    end
    assert_response :redirect

    # Admin
    log_in_as @users[:admin], password: 'secret'
    assert_no_difference 'Location.count' do
      post album_picture_locations_path(@albums[:one], @pictures[:one]),
        params: { location: { invalid: '' } }, as: :json
    end
    assert_response 422
    assert ActiveSupport::JSON.decode(@response.body)

    assert_difference 'Location.count', 1 do
      post album_picture_locations_path(@albums[:one], @pictures[:one]),
        params: { location: { character_id: @characters[:waldo].id, left_coord: 10, right_coord: 20, top_coord: 10, bottom_coord: 20 } }, as: :json
    end
    assert_response :created
    assert ActiveSupport::JSON.decode(@response.body)
  end

  # TODO: json response content
  test "json put/patch update [only admins]" do
    # Guest
    assert_no_changes -> { @locations[:one][:waldo].hint } do
      put album_picture_location_path(@albums[:one], @pictures[:one], @locations[:one][:waldo]),
        params: { location: { hint: 'Updated Hint 1' } }, as: :json
      @locations[:one][:waldo].reload
    end
    assert_response :redirect

    # User
    log_in_as @users[:one]
    assert_no_changes -> { @locations[:one][:waldo].hint } do
      put album_picture_location_path(@albums[:one], @pictures[:one], @locations[:one][:waldo]),
        params: { location: { hint: 'Updated Hint 2' } }, as: :json
      @locations[:one][:waldo].reload
    end
    assert_response :redirect

    # Admin, invalid
    log_in_as @users[:admin], password: 'secret'
    assert_no_changes -> { @locations[:one][:waldo].left_coord } do
      put album_picture_location_path(@albums[:one], @pictures[:one], @locations[:one][:waldo]),
        params: { location: { left_coord: -1 } }, as: :json
      @locations[:one][:waldo].reload
    end
    assert_response 422
    assert ActiveSupport::JSON.decode(@response.body)

    # Admin, valid
    assert_changes -> { @locations[:one][:waldo].hint } do
      put album_picture_location_path(@albums[:one], @pictures[:one], @locations[:one][:waldo]),
        params: { location: { hint: 'Updated Hint 3' } }, as: :json
      @locations[:one][:waldo].reload
    end
    assert_response :success
    assert ActiveSupport::JSON.decode(@response.body) ==
      ActiveSupport::JSON.decode(@locations[:one][:waldo].to_json)
  end

  # TODO: json response content(?)
  test "delete destroy [only admins]" do
    # Guest
    assert_no_difference 'Location.count' do
      delete album_picture_location_path(@albums[:one], @pictures[:one], @locations[:one][:waldo]),
        as: :json
    end
    assert_response :redirect

    # User
    log_in_as @users[:one]
    assert_no_difference 'Location.count' do
      delete album_picture_location_path(@albums[:one], @pictures[:one], @locations[:one][:waldo]),
        as: :json
    end
    assert_response :redirect

    # Admin
    log_in_as @users[:admin], password: 'secret'
    assert_difference 'Location.count', -1 do
      delete album_picture_location_path(@albums[:one], @pictures[:one], @locations[:one][:waldo]),
        as: :json
    end
    assert_response :no_content
  end

end
