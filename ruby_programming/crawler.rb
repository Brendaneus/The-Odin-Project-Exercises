class Node
	def initialize new_value=nil
		@value = new_value
		@parent = nil
		@children = {left: nil, right: nil}
	end

	def value
		@value
	end

	def value=new_value
		@value = new_value
	end

	def parent
		@parent
	end

	def parent=new_node
		@parent = new_node
	end

	def children
		@children
	end

	def children=node_pair
		@children = node_pair
	end
end

class Tree
	attr_accessor :root

	def initialize arr=nil
		build_tree arr unless arr.nil?
	end

	def build_tree arr=[nil]
		@root = Node.new(arr.shift)
		p @root.value
		p arr
		arr.each do |x|
			insert_node(@root, Node.new(x))
		end
		return @root
	end

	def insert_node parent, child
		puts "putting #{child.value} under #{parent.value}"
		child.parent = parent
		left_node = parent.children[:left]
		right_node = parent.children[:right]
		if child.value < parent.value
			puts "#{child.value} < #{parent.value}"
			unless left_node.nil?
				insert_node(left_node, child)
			else
				puts "putting #{child.value} left of #{parent.value}"
				parent.children = {left: child, right: right_node}
			end
		else
			puts "#{child.value} >= #{parent.value}"
			unless right_node.nil?
				insert_node(right_node, child)
			else
				puts "putting #{child.value} right of #{parent.value}"
				parent.children = {left: left_node, right: child}
			end
		end
	end

	def breadth_first_search value
		list = [@root]
		until list.empty?
			current = list.shift
			return current if current.value == value
			list.push current.children[:left] unless current.children[:left].nil?
			list.push current.children[:right] unless current.children[:right].nil?
		end
		nil
	end

	def depth_first_search value
		list = [@root]
		until list.empty?
			current = list.pop
			return current if current.value == value
			list.push current.children[:left] unless current.children[:left].nil?
			list.push current.children[:right] unless current.children[:right].nil?
		end
		nil
	end

	def dfs_rec value, node=nil
		node ||= @root
		puts "matching #{value} to #{node.value}: #{value == node.value}"
		if node.value == value
			return node
		else
			unless node.children[:left].nil?
				puts "left of #{node.value}"
				search_left = dfs_rec(value, node.children[:left]) 
			end
			return search_left unless search_left.nil?
			unless node.children[:right].nil?
				puts "right of #{node.value}"
				search_right = dfs_rec(value, node.children[:right])
			end
		end
		return (!search_left.nil?) ? search_left : (!search_right.nil?) ? search_right : nil
	end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(arr)
p tree.breadth_first_search(23)
puts
p tree.depth_first_search(6345)
puts
p tree.dfs_rec(5)
