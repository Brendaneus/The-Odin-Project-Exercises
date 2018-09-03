def stock_picker prices
	buy = nil
	sell = nil
	profit = 0
	prices.each_with_index do |b, i|
		buy = b if (buy.nil? || i < (prices.length - 1) && b < buy)
		prices.drop(i).each_with_index do |s, j|
			if ((s - b) > profit)
				buy = i
				sell = j + i
				profit = s - b
			end
		end
	end

	return [buy, sell]
end

puts stock_picker([17,3,6,9,15,8,6,1,10])

while true
	puts "Enter stocks (separate by comma):"
	the_stocks = gets.chomp.split().map { |stock| stock.to_i }
	puts stock_picker(the_stocks)
	puts "Again?"
end