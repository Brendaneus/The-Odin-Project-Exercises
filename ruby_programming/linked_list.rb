class LinkedList
	include Enumerable

	attr_accessor :head, :tail

	def initialize
		@head = nil
		@tail = nil
	end

	def head
		(@head.nil?) ? nil : @head.value
	end

	def tail
		(@tail.nil?) ? nil : @tail.value
	end

	def append node
		@head = node if @head.nil?
		@tail.next = node unless @tail.nil?
		@tail = node
	end

	def prepend node
		node.next = @head unless @head.nil?
		@head = node
		@tail = node if @tail.nil?
	end

	def each
		node = @head
		until node.nil?
			yield node.value
			node = node.next
		end
	end

	def size
		i = 0
		each { i += 1 }
		return i
	end

	def at index
		node = @head
		i = 0
		until i == index or (node.next.nil? and ((index - 1) == i))
			node = node.next
			i += 1
		end
		return node.value
	end

	def pop
		last_node = @head
		node = @head
		return nil if @tail.nil? or @head.nil?
		until node.next == nil
			last_node = node
			node = node.next
		end
		@tail = last_node
		last_node.next = nil
		return node
	end

	def contains? match
		result = false
		node = @head
		return result if node.nil?
		until (result == false) or node.next.nil?
			result = node.value == match
			node = node.next
		end
		return result
	end

	def find match
		node = @head
		i = 0
		return node if node.nil?
		until (node.value == match) or node.next.nil?
			i = (node.nil?) ? -1 : (node.next.nil?) ? i : i + 1
			node = node.next unless node.nil?
		end
		return i
	end

	def insert_at index, node
		last_node = nil
		current_node = @head
		i = 0
		until (node.nil?) or (i == index)
			last_node = current_node
			current_node = current_node.next
			i += 1
		end
		return nil if current_node.nil?
		last_node.next = node
		node.next = current_node
		to_s
	end

	def remove_at index
		last_node = nil
		node = @head
		i = 0
		until node.nil? or i == index
			last_node = node
			node = node.next
			i = (node.nil?) ? -1 : i + 1
		end
		return nil if node.nil?
		last_node.next = node.next
		to_s
	end

	def to_s
		string = ""
		node = @head
		until node.nil? or node.next.nil?
			string += "( #{node.value} ) -> "
			node = node.next
		end
		string += "nil"
	end
end

class Node
	attr_accessor :value, :next

	def initialize new_value=nil
		@value = new_value
		@next = nil
	end
end

test_list = LinkedList.new
5.times { |i| test_list.prepend(Node.new(4 - i)) }
5.times { |i| test_list.append(Node.new(5 + i)) }
puts "EACH"
test_list.each { |x| p x }
puts "SIZE"
p test_list.size
puts "HEAD"
p test_list.head
puts "TAIL"
p test_list.tail
puts "AT"
p test_list.at(6)
puts "POP"
p test_list.pop.value
puts "CONTAINS"
p test_list.contains?(3)
puts "FIND"
p test_list.find(7)
puts "TO_S"
p test_list.to_s
puts "INSERT AT"
p test_list.insert_at(2, Node.new("TWOFER"))
puts "REMOVE AT"
p test_list.remove_at(5)
