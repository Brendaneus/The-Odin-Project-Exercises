def substrings target, dictionary
	target.downcase!
	dictionary.map { |word| word.downcase! }
	finds = {}
	dictionary.each do |word|
		target.each_char.with_index do |c, i|
			if target[i...(i + word.length)].include?(word)
				finds[word] = 0 if finds[word].nil?
				finds[word] += 1
			end
		end
	end

	return finds
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
puts substrings("below", dictionary)
puts substrings("Howdy partner, sit down! How's it going?", dictionary)