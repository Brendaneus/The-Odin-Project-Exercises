require 'test_helper'

class ScoresControllerTest < ActionDispatch::IntegrationTest
  
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

    # Ordered by pictures, then characters
    @locations = {
      one: {
        waldo: locations(:one_waldo),
        wenda: locations(:one_wenda),
        odlaw: locations(:one_odlaw)
      },
      two: {
        wizard: locations(:two_wizard),
        woof: locations(:two_woof)
      }
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

  test "get index" do
    get album_picture_scores_path(@albums[:one], @pictures[:one][:one])
    assert_response :success
  end

  test "post create" do
    # Guest
    assert_difference 'Score.count', 1 do
      post album_picture_scores_path(@albums[:one], @pictures[:one][:one])
    end
    assert score_set?

    # User
    log_in_as @users[:one]
    assert_difference 'Score.count', 1 do
      post album_picture_scores_path(@albums[:one], @pictures[:one][:one])
    end
    assert score_set?
  end

  test "get load [only authorized]" do
    build_session

    # Guest
    assert_no_changes -> { score_set? }, from: false do
      get load_album_picture_score_path(@albums[:one], @pictures[:one][:one], @scores[:guest][:one])
    end
    assert_response :redirect

    # User - unauthorized
    log_in_as @users[:one]
    assert_no_changes -> { score_set? }, from: false do
      get load_album_picture_score_path(@albums[:one], @pictures[:one][:one], @scores[:guest][:one])
    end
    assert_response :redirect

    # User - authorized
    assert_changes -> { score_set_as? @scores[:one][:one] }, from: false, to: true do
      get load_album_picture_score_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one])
    end
    assert_response :redirect
  end

  # TODO: authorization
  test "get hints" do
    formatted_results = []
    @pictures[:one][:one].locations.includes(:character).each do |location|
      formatted_results << {
        'id' => location.character.id,
        'name' => location.character.name,
        'avatar_url' => avatar_url_for(location.character),
        'hint' => location.hint,
        'available' => !@scores[:one][:one].locations.include?(location)
      }
    end

    log_in_as @users[:one]
    set_score_as @scores[:one][:one]
    get album_picture_score_hints_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one])
    assert ActiveSupport::JSON.decode(@response.body) ==
      ActiveSupport::JSON.decode(formatted_results.to_json)
  end

  test "json get matches [only authorized with score]" do
    # User, score unset
    log_in_as @users[:one]
    get album_picture_score_matches_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one])
    assert_response :redirect
    
    # User, unauthorized
    set_score_as @scores[:one][:one]
    get album_picture_score_matches_path(@albums[:one], @pictures[:one][:one], @scores[:one][:two])
    assert_response :redirect

    # User, authorized
    get album_picture_score_matches_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one])
    assert_response :success
    assert ActiveSupport::JSON.decode(@response.body) ==
      ActiveSupport::JSON.decode(@scores[:one][:one].locations.to_json)
  end

  # TODO: Test for bad_response/error?
  test "json post guess [only authorized with score]" do
    # User, score unset
    log_in_as @users[:one]
    post album_picture_score_guess_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one]),
      params: {
        guess: {
          character_id: @characters[:waldo].id,
          x_coord: @locations[:one][:waldo].left_coord,
          y_coord: @locations[:one][:waldo].top_coord,
        }
      }
    assert_response :redirect

    # User, unauthorized
    set_score_as @scores[:one][:one]
    post album_picture_score_guess_path(@albums[:one], @pictures[:one][:one], @scores[:one][:two]),
      params: {
        guess: {
          character_id: @characters[:waldo].id,
          x_coord: @locations[:one][:waldo].left_coord,
          y_coord: @locations[:one][:waldo].top_coord,
        }
      }
    assert_response :redirect

    # User, invalid
    set_score_as @scores[:one][:one]
    post album_picture_score_guess_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one]),
      params: {
        guess: {
          character: nil,
        }
      }
    assert_response 422

    # User, valid, non-discovery, unfinished
    post album_picture_score_guess_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one]),
      params: {
        guess: {
          character_id: @characters[:waldo].id,
          x_coord: @locations[:one][:waldo].left_coord,
          y_coord: @locations[:one][:waldo].top_coord,
        }
      }
    assert_response :success
    assert ActiveSupport::JSON.decode(@response.body)["discovery"] == false
    assert ActiveSupport::JSON.decode(@response.body)["finished"] == false

    # User, valid, discovery, unfinished
    post album_picture_score_guess_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one]),
      params: {
        guess: {
          character_id: @characters[:wenda].id,
          x_coord: @locations[:one][:wenda].left_coord,
          y_coord: @locations[:one][:wenda].top_coord,
        }
      }
    assert_response :success
    assert ActiveSupport::JSON.decode(@response.body)["discovery"] == true
    assert ActiveSupport::JSON.decode(@response.body)["finished"] == false

    # User, valid, discovery, finished
    post album_picture_score_guess_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one]),
      params: {
        guess: {
          character_id: @characters[:odlaw].id,
          x_coord: @locations[:one][:odlaw].left_coord,
          y_coord: @locations[:one][:odlaw].top_coord,
        }
      }
    assert_response :success
    assert ActiveSupport::JSON.decode(@response.body)["discovery"] == true
    assert ActiveSupport::JSON.decode(@response.body)["finished"] == true
  end

  # TODO: last_active changes?
  test "get quit" do
    # Guest
    set_new_score_for @albums[:one], @pictures[:one][:one]
    assert_changes -> { score_set? }, from: true, to: false do
      get quit_album_picture_scores_path(@albums[:one], @pictures[:one][:one])
    end

    # User, Score unset
    log_in_as @users[:one]
    assert_no_changes -> { score_set? }, from: false do
      get quit_album_picture_scores_path(@albums[:one], @pictures[:one][:one])
    end

    # User, Score set
    set_score_as @scores[:one][:one]
    assert_changes -> { score_set_as? @scores[:one][:one] }, from: true, to: false do
      get quit_album_picture_scores_path(@albums[:one], @pictures[:one][:one])
    end
  end

  test "delete destroy [only authorized and admins]" do
    # Guest
    assert_no_difference 'Score.count' do
      delete album_picture_score_path(@albums[:one], @pictures[:one][:one], @scores[:guest][:one])
    end

    # User, unauthorized
    log_in_as @users[:one]
    assert_no_difference 'Score.count' do
      delete album_picture_score_path(@albums[:one], @pictures[:one][:one], @scores[:guest][:one])
    end

    # User, authorized
    assert_difference 'Score.count', -1 do
      delete album_picture_score_path(@albums[:one], @pictures[:one][:one], @scores[:one][:one])
    end

    # Admin
    log_in_as @users[:admin], password: 'secret'
    assert_difference 'Score.count', -1 do
      delete album_picture_score_path(@albums[:one], @pictures[:one][:one], @scores[:guest][:one])
    end
  end

end
