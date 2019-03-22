class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "New account successfully created!"
      session[:user_id] = @user.id
  		redirect_to user_path(@user)
  	else
  		flash.now[:failure] = "There was a problem creating this user account."
  		render :new
  	end
  end

  def show
  	@user = User.find( params[:id] )
    @created_events = @user.created_events.order(date: :desc)
  end

  private
  	def user_params
  		params.require(:user).permit(:name)
  	end
end
