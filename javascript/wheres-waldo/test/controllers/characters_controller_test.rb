require 'test_helper'

class CharactersControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @characters = {
      waldo: characters(:waldo),
      wenda: characters(:wenda),
      odlaw: characters(:odlaw),
      wizard: characters(:wizard),
      woof: characters(:woof)
    }

    @characters.each do |key, character|
      character.avatar.attach(io: File.open("public/characters/#{key}.jpg"), filename: "#{key.to_s}.jpg")
    end

    @users = {
      admin: users(:admin),
      one: users(:one),
      two: users(:two)
    }
  end

  test "get index" do
    get characters_path
    assert_response :success
  end

  test "get show" do
    get character_path(@characters[:waldo])
    assert_response :success
  end

  test "get new [only admins]" do
    # Guest
    get new_character_path
    assert_response :redirect

    # User
    log_in_as @users[:one]
    get new_character_path
    assert_response :redirect

    # Admin
    log_in_as @users[:admin], password: 'secret'
    get new_character_path
    assert_response :success
  end

  # TODO - Add pictures
  test "post create [only admins]" do
    # Guest
    assert_no_difference 'Character.count' do
      post characters_path,
        params: { character: { name: 'New Character 1' } }
    end

    # User
    log_in_as @users[:one]
    assert_no_difference 'Character.count' do
      post characters_path,
        params: { character: { name: 'New Character 2' } }
    end

    # Admin, invalid
    log_in_as @users[:admin], password: 'secret'
    assert_no_difference 'Character.count' do
      post characters_path,
        params: { character: { name: '' } }
    end

    # Admin, valid
    assert_difference 'Character.count', 1 do
      post characters_path,
        params: { character: { name: 'New Character 3' } }
    end
  end

  test "get edit [only admins]" do
    # Guest
    get edit_character_path(@characters[:waldo])
    assert_response :redirect

    # User
    log_in_as @users[:one]
    get edit_character_path(@characters[:waldo])
    assert_response :redirect

    # Admin
    log_in_as @users[:admin], password: 'secret'
    get edit_character_path(@characters[:waldo])
    assert_response :success
  end

  # TODO - Add pictures
  test "put/patch update [only admins]" do
    # Guest / PUT
    assert_no_changes -> { @characters[:waldo].name } do
      put character_path(@characters[:waldo]),
        params: { character: { name: 'Updated Name 1' } }
      @characters[:waldo].reload
    end

    # Guest / PATCH
    assert_no_changes -> { @characters[:waldo].name } do
      patch character_path(@characters[:waldo]),
        params: { character: { name: 'Updated Name 2' } }
      @characters[:waldo].reload
    end

    # User
    log_in_as @users[:one]
    assert_no_changes -> { @characters[:waldo].name } do
      patch character_path(@characters[:waldo]),
        params: { character: { name: 'Updated Name 3' } }
      @characters[:waldo].reload
    end

    # Admin, invalid
    log_in_as @users[:admin], password: 'secret'
    assert_no_changes -> { @characters[:waldo].name } do
      put character_path(@characters[:waldo]),
        params: { character: { name: '' } }
      @characters[:waldo].reload
    end

    # Admin, valid
    assert_changes -> { @characters[:waldo].name } do
      put character_path(@characters[:waldo]),
        params: { character: { name: 'Updated Name 4' } }
      @characters[:waldo].reload
    end
  end

  test "delete destroy [only admins]" do
    # Guest
    assert_no_difference 'Character.count' do
      delete character_path(@characters[:waldo])
    end

    # User
    log_in_as @users[:one]
    assert_no_difference 'Character.count' do
      delete character_path(@characters[:waldo])
    end

    # Admin
    log_in_as @users[:admin], password: 'secret'
    assert_difference 'Character.count', -1 do
      delete character_path(@characters[:waldo])
    end
  end

end
