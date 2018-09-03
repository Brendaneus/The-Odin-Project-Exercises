def bubble_sort arr
	loop do
		check = []
		arr.each_with_index do |x, i|
			arr[i], arr[i+1] = arr[i+1], arr[i] if i+1 < arr.length && arr[i] > arr[i+1]
		end
		arr.length.times do |i|
			check.push i+1 == arr.length || arr[i] <= arr[i+1] #I can't belive it's not short circuit!(TM)
		end
		break if check.all?
	end
	return arr
end

def bubble_sort_by arr
	loop do
		check = []
		arr.each_with_index do |x, i|
			arr[i], arr[i+1] = arr[i+1], arr[i] if i+1 < arr.length && (yield arr[i], arr[i+1]) > 0
		end
		arr.length.times do |i|
			check.push (i+1 == arr.length || yield(arr[i], arr[i+1]) <= 0) #I can't belive it's not short circuit!(TM)
		end
		break if check.all?
	end
	return arr
end

input = nil
until input == "exit" || input == "no"
	puts "Create an array:"
	my_arr = []
	i = 0
	my_num = nil
	until my_num == ""
		puts "Enter a#{(i > 0) ? "nother" : ""} value:"
		my_num = gets.chomp
		my_arr.push(my_num.to_i) unless my_num == ""
		i+=1
	end
	p "bubble_sort(#{my_arr}): #{bubble_sort(my_arr)}"
	p "bubble_sort_by(#{my_arr}): #{bubble_sort_by(my_arr) { |x, y| x - y }}"
	puts "Continue?"
	input = gets.chomp.downcase
end