class Book
	attr_accessor :title

	def title=(book) #'method=(args)' What is this where in the curriculum??
		lowercase = ['and', 'but', 'in', 'the', 'of', 'to', 'a', 'an']

		@title = book.split.map.with_index { |word, index|
			if (lowercase.include?(word.downcase) && index != 0)
				word
			else
				word.capitalize
			end
		}.join(' ')
	end
end
