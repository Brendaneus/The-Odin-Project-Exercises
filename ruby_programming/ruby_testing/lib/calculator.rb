class Calculator
	def add(a,b, *more)
		sum = a + b
		more.each { |x| sum += x }
		return sum
	end

	def subtract(a,b, *more)
		difference = a - b
		more.each { |x| difference -= x }
		return difference
	end

	def multiply(a,b, *more)
		product = a * b
		more.each { |x| product *= x }
		return product
	end

	def divide(a,b, *more)
		quotient = a / b
		more.each { |x| quotient /= x }
		return quotient
	end
end