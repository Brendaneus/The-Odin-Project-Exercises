class PicturesController < ApplicationController
  
  before_action :set_album
  before_action :set_picture, except: [:new, :create]
  before_action :require_admin, except: [:show, :characterlist, :hints]
  before_action :require_score, only: :show

  def show
    @score = current_score
    @playing_game = true

    if @score.picture == @picture
      @score.add_time
      @score.update(last_active: Time.now)
    else
      @score.add_time
      unset_score
      flash[:error] = "There was a problem loading your score with this picture."
      redirect_back fallback_location: root_path
    end
  end

  def selections
    @characters = Character.all

    @selections = @characters.as_json.each_with_index.map do |character, index|
      character.keys.zip(character.values).push(
        ['avatar_url', avatar_url_for(@characters[index])],
        ['available', @picture.locations.none? { |location| (location.character_id == character['id']) }]
      ).to_h
    end

    render json: @selections
  end

  def new
    @picture = @album.pictures.new
  end

  def create
    @picture = @album.pictures.build(picture_params)

    if @picture.save
      flash[:notice] = "New Picture '#{@picture.title}' created."
      redirect_to edit_album_picture_path(@album, @picture)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @picture.update(picture_params)
      flash[:success] = "The picture was successfully updated."
      redirect_to edit_album_picture_path(@album, @picture)
    else
      flash[:failure] = "There was a problem updating this picture."
      render :edit
    end
  end

  def destroy
    if @picture.destroy
      flash[:success] = "The picture was successfully deleted."
      redirect_to album_path(@album)
    else
      flash[:success] = "There was a problem deleting this picture."
      redirect_back fallback_location: root_path
    end
  end

  private

    def set_album
      @album = Album.find(params[:album_id])
    end

    def set_picture
      if params[:picture_id].present?
        @picture = @album.pictures.find(params[:picture_id])
      else
        @picture = @album.pictures.find(params[:id])
      end
    end

    def picture_params
      params.require(:picture).permit(:title, :image)
    end

    def require_score
      unless score_set?
        flash[:warning] = "A score must be loaded to start the game."
        redirect_to album_path(@album)
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
