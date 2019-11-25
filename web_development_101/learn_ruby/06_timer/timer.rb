class Timer
	attr_accessor :time
	attr_reader :hours
	attr_reader :minutes
	attr_reader :seconds

	def initialize
		@time = Time.new(0)
		@hours = @time.strftime("%H").to_i
		@minutes = @time.strftime("%M").to_i
		@seconds = @time.strftime("%S").to_i
	end

	def seconds=(num)
		while (num >= 60)
			num -= 60
			self.minutes=(@minutes + 1)
		end

		@time = Time.new(0, 1, 1, @hours, @minutes, num)
		@seconds = @time.strftime("%S").to_i
	end

	def minutes=(num)
		while (num >= 60)
			puts num
			num -= 60
			self.hours=(@hours + 1)
		end

		@time = Time.new(0, 1, 1, @hours, num, @seconds)
		@minutes = @time.strftime("%M").to_i
	end

	def hours=(num)
		while (num >= 24)
			num -= 24
		end

		@time = Time.new(0, 1, 1, num, @minutes, @seconds)
		@hours = @time.strftime("%H").to_i
	end

	def time_string
		@time.strftime("%H:%M:%S")
	end
end
