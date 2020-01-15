class CharactersController < ApplicationController

  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_character, only: [:show, :edit, :update, :destroy]

  def index
    @characters = Character.all

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @characters }
    end
  end

  def show
  end

  def new
    @character = Character.new
  end

  def create
    @character = Character.new(character_params)

    if @character.save
      flash[:success] = "The character was successfully created."
      redirect_to @character
    else
      flash[:failure] = "There was a problem creating this character."
      render :new
    end
  end

  def edit
  end

  def update
    if @character.update(character_params)
      flash[:success] = "The character was successfully updated."
      redirect_to @character
    else
      flash[:failure] = "There was a problem updating this character."
      render :edit
    end
  end

  def destroy
    if @character.destroy
      flash[:success] = "The character was successfully deleted."
      redirect_to characters_path
    else
      flash[:failure] = "There was a problem destroying the character."
      redirect_to characters_path
    end
  end

  private

    def character_params
      params.require(:character).permit(:name, :avatar)
    end

    def set_character
      @character = Character.find(params[:id])
    end

    def avatar_url_for character
      if character.avatar.attached?
        url_for(character.avatar.variant(resize: '160x160'))
      else
        ''
      end
    end

end
