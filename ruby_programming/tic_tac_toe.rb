#TODO:
#Add smart AI (check for opportunities to block opponent before choice)
#Clean up and refactor new stuff
#
#Self contained game.  Create an instance and call #play to start the match.
class TicTacToe
	@@matches = {0 => [:tl, :tc, :tr], 1 => [:tl, :mc, :br], 2 => [:tl, :ml, :bl], 3 => [:tc, :mc, :bc], 4 => [:tr, :mr, :br], 5 => [:ml, :mc, :mr], 6 => [:bl, :mc, :tr], 7 => [:bl, :bc, :br]}

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
		@turn_count = 0
	end

	#Set options and run game until match is made or board is full
	def set
		choose_mode
		puts
		choose_mark
		puts
		while @board.any? { |x, y| y == ' ' }
			turn
			return if match?
			switch
			@turn_count += 1
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
		return attempt_match if @mode == 1 and @player == 2

		puts "Choose a space:"
		display number_board if @turn_count < @player

		choice = ''
		until number_board.has_value? choice
			choice = gets.chomp
			display number_board if choice.upcase == 'K' or choice.upcase == "KEY"
			exit if choice.upcase == 'Q' or choice.upcase == "QUIT"
			puts "Enter '1' through '9' to make a choice.  (K)ey for choices.  (Q)uit to cancel." if choice !~ /^[1-9]{1}$/
			puts "This space is occupied" if !number_board.has_value? choice and choice =~ /^[1-9]{1}$/
		end
		return choice
	end

	#Choose space for AI
	def attempt_match
		cpu_mark = (@mark == 'X') ? 'O' : 'X'
		match_choice = find_match cpu_mark, true
		choice = ''
		if match_choice
			until number_board.has_value? choice and choice =~ /^\d{1}$/
				choice = number_board[match_choice[rand(3)]]
			end
		else
			until number_board.has_value? choice
				choice = (rand(9) + 1).to_s
			end
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
		@board[number_board.key(choice)] = (@player == 1) ? @mark : (@mark == 'X') ? 'O' : 'X'
	end

	#Fill empty board spaces with numbers for selection
	def number_board
		i = 0
		return @board.map do |x, y|
			i += 1
			if (y =~ /^[XO]{1}$/)
				[x, y]
			else
				[x, i.to_s]
			end
		end.to_h
	end

	#Print victory message if any matches are made
	def match?
		player_mark = (@player == 1) ? 'X' : (@mark == 'X') ? 'O' : 'X'
		if find_match player_mark, false
			victory
			true
		end
	end

	#Find first matched row, or attempt finding matches in random order
	def find_match mark, choosing
		if choosing
			order = [0,1,2,3,4,5,6,7]
			order.shuffle!
			@@matches[order.find { |x| (@board[@@matches[x][0]] == mark or @board[@@matches[x][0]] == ' ') and 
									   (@board[@@matches[x][1]] == mark or @board[@@matches[x][1]] == ' ') and 
								 	   (@board[@@matches[x][2]] == mark or @board[@@matches[x][2]] == ' ') }]
		else
			@@matches.find { |x, y| @board[y[0]] == mark and @board[y[0]] == @board[y[1]] and @board[y[1]] == @board[y[2]] }
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