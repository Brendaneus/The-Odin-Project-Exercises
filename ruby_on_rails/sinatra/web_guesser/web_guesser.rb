# TODO
# <<< CLEANUP VARIABLES >>>
# Add check background method
# Add check for non integer parameters
# Lower minimum secret number to 0 (negatives, etc?)

require 'sinatra'
require 'sinatra/reloader'

@@secret_number = rand(100) + 1

@background = 'lightblue'
@@guesses = 5

get '/' do
	puts "secret number = #{@@secret_number}"
	guess = params["guess"].to_i
	message = check_guess(guess)
	erb :index, :locals => {:number => @@secret_number, :message => message, :bg_color => @@background}
end

def check_guess guess
	if @@guesses == 0
		@@guesses = 5
		@@secret_number = rand(100) + 1
		@@background = 'white'
		return "Out of guesses; restarting"
	end

	puts "GUESSES LEFT: #{@@guesses}"
	@@guesses -= 1 unless params.empty?

	if guess == 0
		@@background = 'white'
		nil
	elsif guess == @@secret_number
		@@guesses = 5
		@@secret_number = rand(100) + 1
		@@background = 'green'
		"Match"
	elsif guess > @@secret_number
		if guess - 5 > @@secret_number
			@@background = 'red'
			"Way too high"
		else
			@@background = '#F55'
			"Too high"
		end
	elsif guess < @@secret_number
		if guess + 5 < @@secret_number
			@@background = 'red'
			"Way too low"
		else
			@@background = '#F55'
			"Too low"
		end
	else
		@@background = '#010101'
		"Exception!"
	end
end
