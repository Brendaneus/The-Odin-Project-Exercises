class PostsController < ApplicationController
	before_action :require_login, only: [:new, :create]

	def index
		@posts = Post.all
		@user = current_user
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		if @post.save
			flash[:success] = "New post created."
			redirect_to posts_path
		else
			flash.now[:error] = "There was a problem with your post."
			render :new
		end
	end

	private

		def require_login
			unless signed_in?
				flash[:error] = "You must be signed in to make a post."
				redirect_to '/signin'
			end
		end

		def post_params
			params.require(:post).permit(:title, :body)
		end
end
