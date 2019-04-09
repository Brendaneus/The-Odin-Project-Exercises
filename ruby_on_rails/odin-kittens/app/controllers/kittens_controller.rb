class KittensController < ApplicationController

	def index
		@kittens = Kitten.all
		respond_to do |format|
			format.html
			format.json { render json: @kittens }
		end
	end

	def show
		@kitten = Kitten.find(params[:id])
		respond_to do |format|
			format.html
			format.json { render json: @kitten }
		end
	end

	def new
		@kitten = Kitten.new
	end

	def create
		@kitten = Kitten.new(kitten_params)
		if @kitten.save
			flash[:success] = "Kitten was created!"
			redirect_to @kitten
		else
			flash[:failure] = "Kitten couldn't be created."
			render :new
		end
	end

	def edit
		@kitten = Kitten.find(params[:id])
	end

	def update
		@kitten = Kitten.find(params[:id])
		if @kitten.update_attributes(kitten_params)
			flash[:success] = "Kitten was updated!"
			redirect_to @kitten
		else
			flash[:failure] = "Kitten couldn't be updated."
			render :edit
		end
	end

	def destroy
		@kitten = Kitten.find(params[:id])
		if @kitten.destroy
			flash[:success] = "Kitten was destroyed!"
			redirect_to kittens_path
		else
			flash[:failure] = "Kitten couldn't be destroyed."
			redirect_back fallback_location: kittens_path
		end
	end


	private

		def kitten_params
			params.require(:kitten).permit(:name, :age, :cuteness, :softness)
		end

end
