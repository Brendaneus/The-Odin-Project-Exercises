ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def require_session_build
    session.nil? rescue raise "Sessions not yet built"
  end

  # Fix this and below to raise both requirement exceptions?
  def require_logged_in as: nil
    if as.nil?
      raise "Not yet logged in" unless logged_in?
    else
      raise "Not logged yet in as #{as.name}" unless logged_in_as? as
    end
  end

  def require_score_set as: nil
    if as.nil?
      raise "Score not yet set" unless score_set?
    else
      raise "Score not yet set as score ##{as.id}" unless score_set_as? as
    end
  end

  def build_session
    log_in_as users(:admin), password: 'secret'
    log_out
  end

  def log_in_as user, password: 'password'
    post login_url, params: { name: user.name, password: password }
    require_logged_in as: user
  end

  def log_out
    get logout_url
  end

  def logged_in?
    require_session_build
    !!(session[:user_id] && User.find( session[:user_id] ))
  end

  def logged_in_as? user
    require_session_build
    session[:user_id] == user.id
  end

  def set_new_score_for album, picture
    post album_picture_scores_path(album, picture)
    require_score_set
  end

  def set_score_as score
    if score.owned?
      require_logged_in as: score.user
    else
      raise "Guest scores cannot be set"
    end
    get load_album_picture_score_path(score.picture.album, score.picture, score)
    require_score_set as: score
  end

  def current_score
    session[:score_id] && Score.find( session[:score_id] )
  end

  def score_set?
    require_session_build
    !current_score.nil?
  end

  def score_set_as? score
    require_session_build
    session[:score_id] == score.id
  end

  def avatar_url_for character
    if character.avatar.attached?
      url_for(character.avatar.variant(resize: '160x160'))
    else
      ''
    end
  end

end
