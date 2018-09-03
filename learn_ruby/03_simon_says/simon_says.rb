def echo (phrase)
	phrase
end

def shout (phrase)
	phrase.upcase
end

def repeat (phrase, n = 2)
	output = phrase
	(n - 1).times do
		output += ' ' + phrase
	end

	output
end

def start_of_word (phrase, i)
	phrase[0, i]
end

def first_word (phrase)
	phrase.split.first
end

def titleize (phrase)
	phrase.split.map.with_index { |word, index|
		if ((word == 'and' || word == 'or' || word == 'the' || word == 'over') && index != 0) #There must be a better way to check for these
			word
		else
			word.capitalize
		end
	}.join(' ')
end