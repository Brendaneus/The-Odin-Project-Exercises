def merge_sort arr
	return arr unless arr.length > 1
	
	arr_A = merge_sort arr[0...(arr.length / 2)]
	arr_B = merge_sort arr[(arr.length / 2)..(-1)]
	arr_C = []

	until arr_A.empty? and arr_B.empty?
		if arr_A.empty?
			arr_C.push arr_B.shift
		elsif arr_B.empty?
			arr_C.push arr_A.shift
		elsif arr_A.first < arr_B.first
			arr_C.push arr_A.shift
		else
			arr_C.push arr_B.shift
		end
	end
	
	return arr_C
end

puts "[5, 4, 3, 2, 1, 0] sorted is #{merge_sort [5,4,3,2,1,0]}\n"
puts "[6, 21, -1, 5092, 3] sorted is #{merge_sort [3,6,21,-1,5092]}"
