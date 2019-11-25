def add (total, addend)
	total + addend
end

def subtract (minuend, subtrahend)
	minuend - subtrahend
end

def sum (series)
	series.reduce(0) {|total, addend| add(total, addend)}
end

def multiply (*args)
	args.reduce(1) {|multiplicand, multiplier| multiplicand * multiplier}
end

def power (base, exponent)
	base ** exponent
end

def factorial (number)
	return 0 if (number == 0)

	total = 1
	number.times do |i|
		total *= (i + 1)
	end

	total
end