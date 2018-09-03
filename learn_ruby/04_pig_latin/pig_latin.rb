def translate (phrase)
	phrase.split.map { |word| 
		special_chars_pre = ''
		special_chars_post = ''

		letters_start = 0
		letters_end = word.length - 1
		while (!word[0].downcase.match(/[a-z]/))
			special_chars_pre += word[0]
			letters_start += 1
			word = word[1..-1]
		end
		while (!word[-1].downcase.match(/[a-z]/))
			letters_end -+ 1
			special_chars_post = word[-1] + special_chars_post
			word = word[0..-2]
		end

		if (word.start_with?('a', 'e', 'i', 'o', 'u'))
			if word.match(/[A-Z]/)
				special_chars_pre + (word + 'ay').capitalize + special_chars_post
			else
				special_chars_pre + word + 'ay' + special_chars_post
			end
		else
			last_index = 0
			word.each_char do |letter|
				break if (letter == 'a' || letter == 'e' || letter == 'i' || letter == 'o' || (letter == 'u' && word[last_index - 1] != 'q'))
				last_index += 1
			end

			if word.match(/[A-Z]/)
				special_chars_pre + (word[last_index..-1] + word[0..last_index - 1] + 'ay').capitalize + special_chars_post
			else
				special_chars_pre + word[last_index..-1] + word[0..last_index - 1] + 'ay' + special_chars_post
			end
		end
	}.join(' ')
end