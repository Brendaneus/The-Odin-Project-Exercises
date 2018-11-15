#TODO:
#Add smart AI (check for possible matches before choice)
#
#
#Self contained game.  Create an instance and call #play to start the match.
class TicTacToe
	def initialize
		reset
	end

	#Print message and empty board at first game
	def welcome
		first_time = false
		puts "Welcome to Tic-Tac-Toe!"
		display
	end

	#Start and loop game
	def play
		welcome
		set
		input = ''
		loop do
			puts "Enter to play again or '(Q)UIT' to stop"
			input = gets.chomp.upcase
			exit if input == 'Q' or input == "QUIT"
			reset
			set
		end
	end

	#Prepare board and player for next game
	def reset
		@board = {tl: ' ', tc: ' ', tr: ' ', ml: ' ', mc: ' ', mr: ' ', bl: ' ', bc: ' ', br: ' '}
		@player = 1
	end

	#Set options and run game until match is made or board is full
	def set
		choose_mode
		puts
		choose_mark
		puts
		# number_board
		while @board.any? { |x, y| y == ' ' }
			turn
			p 'turned'
			return if match?
			switch
		end
		display
		tie
	end

	#Prompt for player vs player or player vs ai
	def choose_mode
		puts "Choose a mode:"
		puts "(1) VS Computer"
		puts "(2) VS Player"
		@mode = nil
		until @mode == 1 or @mode == 2
			@mode = gets.chomp
			exit if @mode.upcase == 'Q' or @mode.upcase == "QUIT"
			@mode = @mode.to_i
			puts "Enter '1' or '2' to make a choice.  (Q)uit to cancel." unless @mode == 1 or @mode == 2
		end
	end

	#Prompt player one for 'X' or 'O' mark
	def choose_mark
		puts "#{@mode == 2 ? "Player 1, " : ''}(O)'s or (X)'s?"
		@mark = nil
		until @mark == 'X' or @mark == 'O'
			@mark = gets.chomp.upcase
			@mark = 'O' if @mark == '0'
			exit if @mark.upcase == 'Q' or @mark.upcase == "QUIT"
			puts "Enter 'X' or 'O' to make a choice.  (Q)uit to cancel." unless @mark == 'X' or @mark == 'O'
		end
	end

	#Show current player, get move, and update board
	def turn
		ready if @mode == 2
		choice = choose_space
		update choice
		display
	end

	#Display ready message for current player
	def ready
		puts
		puts "READY PLAYER #{@player == 1 ? "ONE" : "TWO"}"
		puts
	end

	#Get move for current player
	def choose_space
		return free_space if @mode == 1 and @player == 2

		puts "Choose a space:"
		display number_board

		choice = ''
		until number_board.has_value? choice
			choice = gets.chomp
			exit if choice.upcase == 'Q' or choice.upcase == "QUIT"
			puts "Enter '1' through '9' to make a choice.  (Q)uit to cancel." unless choice =~ /^[1-9]{1}$/
			puts "Space taken" unless number_board.include? choice or choice =~ /[1-9]{1}/
		end
		return choice
	end

	#Choose space for AI
	def free_space
		choice = ''
		until @board.has_value? choice
			choice = (rand(9) + 1).to_s
		end
		return choice
	end

	#Change current player
	def switch
		@player = (@player == 1) ? 2 : 1
	end

	#Show board from input
	def display board=@board
		puts
		puts " #{board[:tl]} ¦ #{board[:tc]} ¦ #{board[:tr]} \n---+---+---\n #{board[:ml]} ¦ #{board[:mc]} ¦ #{board[:mr]} \n---+---+---\n #{board[:bl]} ¦ #{board[:bc]} ¦ #{board[:br]} "
		puts
	end

	#Update board
	def update choice
		@board[@board.key(choice)] = (@player == 1) ? @mark : (@mark == 'X') ? 'O' : 'X'
	end

	#Fill empty board spaces with numbers for selection
	def number_board
		i = 0
		return @board.map do |x, y|
			i += 1
			[x, i.to_s]
		end.to_h
	end

	#Print victory message if any matches are made
	def match?
		if 	((@board[:tl] == @board[:tc] and @board[:tc] == @board[:tr] and @board[:tl] != ' ') or
			(@board[:tl] == @board[:mc] and @board[:mc] == @board[:br] and @board[:tl] != ' ') or
			(@board[:tl] == @board[:ml] and @board[:ml] == @board[:bl] and @board[:tl] != ' ') or
			(@board[:tc] == @board[:mc] and @board[:mc] == @board[:bc] and @board[:tc] != ' ') or
			(@board[:ml] == @board[:mc] and @board[:mc] == @board[:mr] and @board[:ml] != ' ') or
			(@board[:bl] == @board[:bc] and @board[:bc] == @board[:br] and @board[:bl] != ' ') or
			(@board[:bl] == @board[:mc] and @board[:mc] == @board[:tr] and @board[:bl] != ' '))
			victory
		end
	end

	#Print victory message
	def victory
		puts
		puts "CONGRATULATIONS PLAYER #{@player == 1 ? "ONE" : "TWO"}!!"
		puts
	end

	#Print tie message
	def tie
		puts
		puts "NO CONTEST"
		puts
	end
end

test_game = TicTacToe.new; test_game.play #EXAMPLE