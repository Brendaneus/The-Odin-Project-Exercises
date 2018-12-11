# TODO:
# Add main menu and option to load saves in-game
# Implement score counter system persistent across games played in save
# Make data display method
# clean this thing up 

require 'json'
class Hangman # Gallows?
	def initialize(save_index=nil, save_data=nil)
		(save_index.nil?) ? reset : load(save_index, save_data)
	end

	def to_json
		JSON.dump ({
			:secret_word => @secret_word,
			:letters => @letters,
			:words => @words,
			:chances => @chances
		})
	end

	def play
		welcome

		input = ""
		until input =~ /^NO*$/
			start_game
			puts "\nPlay again?"
			print ">"
			input = gets.chomp.upcase
			reset unless input =~ /^NO*$/
		end
		puts "\nQUITTING\n"
	end

	# will not reset score unless passed argument
	def reset(save_data=nil)
		save = JSON.load(save_data) unless save_data.nil?
		@secret_word = (save_data.nil?) ? '' : save["secret_word"]
		until @secret_word.length.between?(5,12)
			@secret_word = File.readlines('5desk.txt').sample.chomp.upcase
		end
		@letters = (save_data.nil?) ? [] : save["letters"]
		@words = (save_data.nil?) ? [] : save["words"]
		@chances = (save_data.nil?) ? 10 : save["chances"]
	end

	def save(save_file=File.open(File.join(Dir.pwd, "saves.txt"), "r+"))
		save_index = save_file.readlines.size
		save_file.puts to_json
		puts "\nSAVED TO SLOT #{save_index}\n"
		save_file.close
	end

	def load(save_index=0, save_file=File.open(File.join(Dir.pwd, "saves.txt"), "r"))
		save_data = save_file.readlines[save_index]
		reset save_data
		puts "\nLOADED FROM SLOT #{save_index}\n"
		save_file.close
	end

	def welcome
		puts
		draw_figure
		puts "-------------------"
		puts "Welcome to Hangman!"
		puts "-------------------"
		gets
	end

	def draw_figure(chances=5)
		puts " ,========+   "
		puts " | /      |   "
		puts " ||      #{(chances > 0) ? "(_)" : "   "}"
		puts " ||      #{(chances > 1) ? "/" : " "}#{(chances > 0) ? "|" : " "}#{(chances > 2) ? "\\" : " "}"
		puts " ||       #{(chances > 0) ? "|" : " "}"
		puts " ||      #{(chances > 3) ? "/" : " "} #{(chances > 4) ? "\\" : " "}"
		puts " ||_          "
		puts "/___\\    #{(chances > 1) ? "_" : " "}#{(chances > 0) ? "_" : " "}#{(chances > 2) ? "_" : " "}"
	end

	def get_hint
		@secret_word.chars.map { |c| (@letters.include? c || c !~ /[A-Z]/) ? c : "_" }.join("")
	end

	def check_guess(guess)
		if guess.length == 1
			@letters.push(guess)
			return (@secret_word == get_hint)
		else
			@words.push(guess)
			return (@secret_word == guess)
		end
	end

	def start_game
		until @chances < 0
			# Convert this to a case statement!!
			puts "#{@chances} turns left" unless @chances == 0
			puts "The executioner is getting bored..." if @chances.between?(2, 5)
			puts "Last chance" if @chances == 1
			puts "Time's up!" if @chances == 0
			draw_figure(@chances)
			puts "-------------------\n" + get_hint unless @chances == 0
			if @chances == 0
				puts "-------------------\nThe word was:\n#{@secret_word}\n\n-------------------\n    GAME  OVER    \n-------------------\n"
				return
			end
			
			puts "\nEnter a letter or word to make a guess.\n"
			guess = ''
			until guess =~ /^[A-Z]+$/ && ( (guess.length == 1 && !@letters.include?(guess)) || (guess.length > 1 && !@words.include?(guess)) ) && guess !~ /^SAVE$/
				print ">"
				guess = gets.chomp.upcase
				puts
				if guess =~ /^SAVE$/
					save
					next
				end
				if guess =~ /^QUIT$/
					exit
				end
				puts "Enter a guess to continue." if guess.length == 0
				puts "Guesses must contain only letters from the alphabet." if guess !~ /^[A-Z]+$/
				puts "This letter has already been used." if guess.length == 1 && @letters.include?(guess)
				puts "This word has already been guessed." if guess.length > 1 && @words.include?(guess)
				puts "Enter 'SAVE' to save game or 'QUIT' to stop." if @count == 10
			end

			if check_guess(guess)
				puts "-------------------"
				puts "  Congratulations! "
				puts "      YOU WIN      "
				puts "-------------------"
				return
			end

			@chances -= 1
		end
	end
end
##
save_file_default = File.open(File.join(Dir.pwd, "saves.txt"), "r")
save_file_default_size = File.readlines(save_file_default).size
puts
puts "Enter a number 0 - #{save_file_default_size - 1} to resume a game." if save_file_default_size > 0
puts "Enter to continue."
input = "NIL"
until input =~ /^\d*$/ && input.to_i < save_file_default_size
	print ">"
	input = gets.chomp
end
save_index_default = (input.empty?) ? nil : input.to_i
test_game = Hangman.new(save_index_default, save_file_default)
test_game.play
