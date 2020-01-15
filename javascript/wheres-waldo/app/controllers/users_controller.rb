class UsersController < ApplicationController

  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_authorize_or_admin, except: [:new, :create]

  def show
    @scores = @user.scores.includes(:picture).finished.order(:finished, :elapsed_time)
    @games = @user.scores.includes(:picture).unfinished
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in_as @user
      flash[:success] = "The user was successfully created"
      redirect_to user_path(@user)
    else
      flash.now[:failure] = "There was a problem creating this user"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "The user was successfully updated"
      redirect_to user_path
    else
      flash[:failure] = "There was a problem updating the user"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      log_out
      flash[:success] = "The user was successfully deleted"
      redirect_to root_path
    else
      flash[:failure] = "There was a problem deleting this user"
      redirect_back fallback_location: root_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_authorize_or_admin
      unless logged_in_as?(@user) || admin_user?
        flash[:warning] = "You are not authorized to do that."
        redirect_back fallback_location: root_path
      end
    end

end
