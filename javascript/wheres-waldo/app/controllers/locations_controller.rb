class LocationsController < ApplicationController

  before_action :require_admin
  before_action :set_album
  before_action :set_picture
  before_action :set_location, only: [:edit, :update, :destroy]

  def index
    @locations = @picture.locations

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @locations.to_json }
    end
  end

  def create
    @location = @picture.locations.new(location_params)
    
    @location.character = Character.find(params[:location][:character_id]) if params[:location][:character_id].present?

    respond_to do |format|
      if @location.save
        format.json { render json: @location.to_json, status: :created }
      else
        format.json { render json: @location.errors.to_json, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update(location_params)
        format.json { render json: @location.to_json }
      else
        format.json { render json: @location.errors.to_json, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @location.destroy
        format.json { render json: {}, status: :no_content }
      else
        format.json { render json: @location.errors.to_json, status: :unprocessable_entity }
      end
    end
  end

  private

    def location_params
      params.require(:location).permit(:left_coord, :right_coord, :top_coord, :bottom_coord, :hint)
    end

    def set_album
      @album = Album.find(params[:album_id])
    end

    def set_picture
      @picture = @album.pictures.find(params[:picture_id])
    end

    def set_location
      @location = @picture.locations.find(params[:id])
    end

end
