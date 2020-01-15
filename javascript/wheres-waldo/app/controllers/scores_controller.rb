class ScoresController < ApplicationController

  before_action :set_album_and_picture
  before_action :set_score, only: [:load, :hints, :matches, :guess, :destroy]
  before_action :require_current_score, only: [:hints, :matches, :guess, :finish]
  before_action :require_login, only: [:load, :destroy]
  before_action :require_authorize, only: [:load]
  before_action :require_authorize_or_admin, only: [:destroy]

  def index
    @scores = @picture.scores.order(:elapsed_time)
  end

  def create
    @score = @picture.scores.build(user: current_user, last_active: DateTime.now)

    if @score.save
      set_score_as @score
      redirect_to album_picture_path(@album, @picture)
    else
      flash[:error] = "There was a problem creating a new game."
      redirect_back fallback_location: root_path
    end
  end

  def load
    current_score.add_time if pending_score?

    unless @score.finished?
      set_score_as @score
      redirect_to album_picture_path(@album, @picture)
    else
      unset_score
      flash[:warning] = "This game has already been finished."
      redirect_back fallback_location: root_path
    end
  end

  def hints
    hints = []
    @picture.locations.includes(:character).each do |location|
      hints << {
        id: location.character.id,
        name: location.character.name,
        avatar_url: avatar_url_for(location.character),
        hint: location.hint,
        available: !@score.locations.include?(location)
      }
    end

    render json: hints
  end

  def matches
    begin
      render json: @score.locations.to_json
    rescue error
      render json: { errors: { exception: error } }, status: :bad_request
    end
  end

  def guess
    character = @picture.characters.find(params[:guess][:character_id]) if params[:guess][:character_id].present?
    coords = [ (guess_params[:x_coord] || -1).to_i, (guess_params[:y_coord] || -1).to_i ]

    begin
      if ( found_location = @picture.get_match(character, coords) )

        discovery = !@score.locations.include?(found_location)
        @score.locations << found_location if discovery

        @score.finish # if possible...

        render json: { discovery: discovery, finished: @score.finished }
      else
        @errors = {}
        if character.nil?
          @errors[:character] = 'required'
          @errors[:character] = 'not in picture' if !@picture.characters.include?(character)
        end
        @errors[:coords] = 'required' if guess_params[:x_coord].nil? || guess_params[:y_coord].nil?

        render json: { errors: @errors }, status: :unprocessable_entity
      end
    rescue error
      render json: { errors: { exception: error } }, status: :bad_request
    end
  end

  def quit
    if pending_score?
      current_score.add_time
      flash[:success] = "Your #{logged_in? ? 'game' : 'score'} has been saved."
    elsif score_set?
      flash[:failure] = "This game is not currently in progress."
    else
      flash[:error] = "There was a problem finding your current game."
    end
    
    unset_score

    redirect_to params[:to_album] ? album_path(@album) : album_picture_scores_path(@album, @picture)
  end

  def destroy
    if @score.destroy
      flash[:success] = "The score was successfully deleted."
      redirect_back fallback_location: root_path
    else
      flash[:failure] = "There was a problem deleting this score."
      redirect_back fallback_location: root_path
    end
  end

  private

    def guess_params
      params.require(:guess).permit(:x_coord, :y_coord, :character_id)
    end

    def set_album_and_picture
      @album = Album.find(params[:album_id])
      @picture = Picture.find(params[:picture_id])
    end

    def set_score
      if params[:score_id]
        @score = Score.find(params[:score_id])
      else
        @score = Score.find(params[:id])
      end
    end

    def require_authorize
      unless logged_in_as? @score.user
        flash[:warning] = "You are not authorized to do that."
        redirect_back fallback_location: root_path
      end
    end

    def require_authorize_or_admin
      unless (logged_in_as? @score.user) || (admin_user?)
        flash[:warning] = "You are not authorized to do that."
        redirect_back fallback_location: root_path
      end
    end
    
    def require_current_score
      unless score_set_as?(@score)
        flash[:warning] = "You are currently not loaded into this game."
        redirect_back fallback_location: root_path
      end
    end

    def avatar_url_for character
      if character.avatar.attached?
        url_for(character.avatar.variant(resize: '160x160'))
      else
        ''
      end
    end

end
