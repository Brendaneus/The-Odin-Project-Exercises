puts "Iterative:"

def fibs num
	total, result = 0, 1
	num.times do |i|
		temp = total
		total += result
		result = temp
	end
	return total
end

11.times do |i|
	p "#{i}: #{fibs(i)}"
end

puts "Recursive:"

def fibs_rec num
	return (num <= 1) ? num : fibs_rec(num - 1) + fibs_rec(num - 2)
end

11.times do |i|
	p "#{i}: #{fibs_rec(i)}"
end