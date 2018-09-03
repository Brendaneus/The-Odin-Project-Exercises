def caesar_cipher phrase, shift
	phrase.split('').map { |char| 
		if (char.match(/[a-z]/))
			((((char.ord - 97) + shift) % 26) + 97).chr
		elsif (char.match(/[A-Z]/))
			((((char.ord - 65) + shift) % 26) + 65).chr
		else
			char
		end
	}.join
end

puts caesar_cipher("What a string!", 5)

while true
	puts "Enter phrase:"
	the_phrase = gets.chomp
	puts "Enter shift:"
	the_shift = gets.chomp.to_i
	puts caesar_cipher(the_phrase, the_shift)
	puts "Again?"
end