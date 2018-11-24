#TODO:
#Eliminate colors from code generation after being ruled out (no red / white)
#Add AI algorhythm to play on hard difficulty
#maybe try refactoring with #rassoc
#add better help -- maybe in each prompt as well as quit function, etc.

class Mastermind
	@@keys = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "PURPLE"]

	def initialize
		p 'init'
	end
	
	def play
		welcome
		set
		start
		loop do
			puts "Enter to play again or '(Q)UIT' to stop"
			input = gets.chomp.upcase
			exit if input == 'Q' or input == "QUIT"
			puts
			puts "---------------"
			puts
			puts
			set
			start
		end
	end

	def welcome
		puts
		puts "--------------------------"
		puts "  Welcome to Mastermind.  "
		puts "--------------------------"
		puts
		puts "Enter 'I' for instructions"
		if gets.chomp.upcase =~ /I/
			print_instructions
		end
	end

	def print_instructions
		puts
		puts "--------------------------"
		puts "The goal of this game is  "
		puts "to break the Mastermind's "
		puts "secret code.              "
		puts
		puts "The code is made of four  "
		puts "keys from the color wheel."
		puts
		puts "When guessing the code, a "
		puts "red key is shown for each "
		puts "matching key, and a white "
		puts "key is shown for any key  "
		puts "detected in the code that "
		puts "is misplaced but matching."
		puts 
		puts "There will be a total of  "
		puts "12 attempts given to break"
		puts "the code.                 "
		puts "If these run out, the     "
		puts "mainframe will lock down. "
		puts
		puts "Good luck."
		puts
		puts "--------------------------"
		puts
	end

	def set
		set_mode
		create_code
		if @mode == 1
			puts "MASTER CODE:"
			display @code
		end
		@red_pairs = {}
		@white_pairs = {}
		if @mode == 1
			@difficulty = 1
			puts "The computer will play on easy."
			puts
		else
			set_difficulty
		end
		puts "---------------"
		@count = 12
	end

	def set_mode
		puts "Do you want to (1)Make the code or (2)Guess?"
		input = ''
		until input =~ /^[12]$/
			input = gets.chomp
			puts "Enter '1' or '2' to make a choice" unless input =~ /^[12]$/
			puts
		end
		@mode = input.to_i
	end

	def set_difficulty
		puts "Select difficulty: (1)Easy or (2)Normal"
		input = ''
		until input =~ /^[12]$/
			input = gets.chomp
			puts "Enter '1' or '2' to make a choice" unless input =~ /^[12]$/
			puts
		end
		@difficulty = input.to_i
	end

	def create_code
		if @mode == 2
			@code = generate_code
		else
			puts "Enter a code of 4 colors:  Red, Orange, Yellow, Green, Blue, or Purple"
			puts
			input = []
			until input.length == 4
				input = gets.chomp.upcase.scan(/(RED|ORANGE|YELLOW|GREEN|BLUE|PURPLE)/).map { |x| x[0] } #whole words only
				puts "You entered \"#{input}\".\nCodes must be exactly 4 colors long." if input.length > 0 and input.length != 4
				puts
			end
			@code = Hash[ input.map.with_index { |x, i| [i, x] } ]
		end
	end

	def generate_code
		Hash[ (0..3).map { |i| [i, @@keys[rand(@@keys.length)]] } ]
	end

	def start
		until @count == 0
			puts "ATTEMPS LEFT: #{@count}" unless @count == 12
			return if turn
			@count -= 1
		end
		deny_access
		gets
	end

	def turn
		puts "---------------"
		puts
		feedback = check attempt_password
		puts "FEEDBACK:"
		display feedback
		if feedback.length == 4 and feedback.all? { |x| x == "RED" }
			grant_access
			return true
		end
		gets if @mode == 1
		false
	end

	def generate_guess
		base = generate_code
		base.merge!(@red_pairs)
		white_keys = @white_pairs.keys
		unassigned_keys = base.keys - @red_pairs.keys
		white_keys.each do |x|
			i = unassigned_keys[rand(unassigned_keys.length)]
			base[i] = @white_pairs[x]
			unassigned_keys.delete(i)
		end
		
		return base
	end

	def attempt_password
		if @mode == 1
			generate_guess
		else
			puts
			puts "Enter passcode:"
			input = []
			until input.length == 4
				input = gets.chomp.upcase.scan(/(RED|ORANGE|YELLOW|GREEN|BLUE|PURPLE)/).map { |x| x[0] }
				puts "You entered \"#{input}\".\nCodes must be exactly 4 colors long." if input.length > 0 and input.length != 4
				puts
			end
			Hash[ input.map.with_index { |x, i| [i, x] } ]
		end
	end

	def check password
		if @mode == 1
			puts "MASTER CODE:"
			display @code
		end
		puts "PASSWORD ENTERED:"
		display password
		codekey = [0,1,2,3]
		passkey = [0,1,2,3]
		@code.length.times do |i|
			if @code[i] == password[i]
				codekey[i] = "RED"
				passkey[i] = "RED"
			end
		end
		@code.length.times do |i|
			next if codekey[i].is_a? String
			match_index = password.find { |x, y| y == @code[i] and passkey[x].is_a? Integer }
			if match_index
				codekey[i] = "WHITE"
				passkey[match_index[0]] = "WHITE"
			end
		end

		if @mode == 1
			@red_pairs = password.select { |x, y| passkey[x] == "RED" }
			@white_pairs = password.select { |x, y| passkey[x] == "WHITE" }
		end

		if @difficulty == 1
			return passkey.each { |x, y| y = "----" if y.is_a? Integer }
		else
			return passkey.select { |x| x.is_a? String }.sort { |x, y| x <=> y }
		end
	end

	def display feedback #FORMAT LATER
		if feedback.is_a? Hash
			p feedback.values 
		else
			p feedback.map { |x| x = (x =~ /^(RED)|(WHITE)$/) ? x : "> <" }
		end
		puts
		
	end

	def grant_access
		puts
		puts "--------------"
		puts "ACCESS GRANTED"
		puts "--------------"
		puts
	end

	def deny_access
		puts
		puts "--------------"
		puts "ACCESS  DENIED"
		puts "--------------"
		puts
	end
end

test_game = Mastermind.new; test_game.play #EXAMPLE