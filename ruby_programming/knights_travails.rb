#TODO:
# Clean this thing up 
# Make recursive method containing all functionality?

class KnightBoard
	def initialize
		@directions = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
	end

	class Space
		attr_reader :location, :last_space

		def initialize location
			@location = location
		end

		def last_space=space
			@last_space = space
		end
	end

	def knight_moves start, target
		#start bfs search
		space = Space.new(start)
		queue = []
		puts "searching..."
		until space.location == target
			@directions.each do |direction|
				new_space = calc_space(space.location, direction)
				if in_bounds?(new_space)
					puts "pushing #{new_space.location}"
					new_space.last_space = space
					queue.push(new_space)
				end
			end
			space = queue.shift
			puts "space: #{space.location}"
		end

		#build path from matching space to starting space
		puts "pathing..."
		path = []
		until space.location == start
			path.unshift(space.location)
			space = space.last_space
			p path
		end
		path.unshift(space.location)

		return path
	end

	def calc_space space, direction
		return Space.new([(space[0] + direction[0]), (space[1] + direction[1])])
	end

	def in_bounds? space
		return (space.location[0] >= 0) && (space.location[0] <= 7) && (space.location[1] >= 0) && (space.location[1] <= 7)
	end
end

puts "Enter two coordinates on a chessboard to find the shortest path a knight must take between them."

puts "Enter x-coord of first space."
xs = gets.chomp.to_i
puts "Enter y-coord of first space."
ys = gets.chomp.to_i
start = [xs,ys]

puts "Enter x-coord of second space."
xt = gets.chomp.to_i
puts "Enter y-coord of second space."
yt = gets.chomp.to_i
target = [xt,yt]

test_board = KnightBoard.new
puts "Path from #{start} to #{target} is #{test_board.knight_moves(start, target)}"
