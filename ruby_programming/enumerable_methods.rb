module Enumerable
	# TODO: if no arg is given, return enumerator
	def my_each
		if self.is_a? Array
			for x in self
				yield x
			end
		end
		if self.is_a? Hash
			for x, y in self
				yield x, y
			end
		end
		return self
	end

	# TODO: if no arg is given, return enumerator
	def my_each_with_index
		i = 0
		if self.is_a? Array
			for x in self
				yield x, i
				i += 1
			end
		end
		if self.is_a? Hash
			for x, y in self
				yield x, y, i
				i += 1
			end
		end
		return self
	end

	# TODO: if no arg is given, return enumerator
	def my_select
		if self.is_a? Array
			my_arr = []
			for x in self
				my_arr.push if yield x
			end
			return my_arr
		end
		if self.is_a? Hash
			my_hash = {}
			for x, y in self
				my_hash.push if yield x, y
			end
			return my_hash
		end
	end

	def my_all?
		if self.is_a? Array
			for x in self
				if block_given?
					return false unless yield x
				else
					return false unless x
				end
			end
		end
		if self.is_a? Hash
			for x, y in self
				if block_given?
					return false unless yield y
				else
					return false unless y
				end
			end
		end
		return true
	end

	def my_any?
		if self.is_a? Array
			for x in self
				if block_given?
					return true if yield x
				else
					return true if x
				end
			end
		end
		if self.is_a? Hash
			for x, y in self
				if block_given?
					return true if yield y
				else
					return true if y
				end
			end
		end
		return false
	end

	def my_none?
		if self.is_a? Array
			for x in self
				if block_given?
					return false if yield x
				else
					return false if x
				end
			end
		end
		if self.is_a? Hash
			for x, y in self
				if block_given?
					return false if yield y
				else
					return false if y
				end
			end
		end
		return true
	end

	def my_count target=nil
		i = 0
		if block_given? && target
			throw Error.new "Can't use argument AND block"
		elsif block_given? || target
			if self.is_a? Array
				for x in self
					if block_given?
						i += 1 if yield x
					else
						i += 1 if x == target
					end
				end
			end
			if self.is_a? Hash
				for x, y in self
					if block_given?
						i += 1 if yield y
					else
						i += 1 if y == target
					end
				end
			end
		else
			return self.length
		end
		return i
	end

	# TODO: if no arg is given, return enumerator
	def my_map my_proc=nil
		if self.is_a? Array
			my_arr = []
			for x in self
				my_arr.push(yield x) unless my_proc
				my_arr.push(my_proc.call(x)) if my_proc
			end
			return my_arr
		end
		if self.is_a? Hash
			my_hash = {}
			for x, y in self
				my_hash[x] = yield y unless my_proc
				my_hash[x] = my_proc.call(y) if my_proc
			end
			return my_hash
		end
	end

	def my_inject (arg1=nil, arg2=nil)
		if arg1 && arg2
			total = arg1
			if self.is_a? Array
				for x in self
					total = total.public_send(arg2, x)
				end
			end
			if self.is_a? Hash
				for x, y in self
					total = total.public_send(arg2, y)
				end
			end
		elsif arg1 && block_given?
			total = arg1
			if self.is_a? Array
				for x in self
					total = yield total, x
				end
			end
			if self.is_a? Hash
				for x, y in self
					total = yield total, y
				end
			end
		elsif arg1
			if self.is_a? Array
				for x in self
					total = total.public_send(arg1, x) if total
					total ||= x
				end
			end
			if self.is_a? Hash
				for x, y in self
					total = total.public_send(arg1, self[x]) if total
					total ||= y
				end
			end
		else
			if self.is_a? Array
				for x in self
					total = yield total, x if total
					total ||= x
				end
			end
			if self.is_a? Hash
				for x, y in self
					total = yield total, y if total
					total ||= y
				end
			end
		end
		return total
	end
end

my_hash = {a: 1, b: 3, c: 9}
my_proc = Proc.new {|x| x ** x}
p my_array.my_map(&my_proc) {|x| x * -1} #SyntaxError: both block arg and actual block given -- ruby 2.3.7p456 (2018-03-28 revision 63024) [x86_64-linux] Ubuntu 18.04