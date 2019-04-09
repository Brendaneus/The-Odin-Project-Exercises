# Create Kittens
unless Kitten.any?
	Kitten.create!(name: "Kitty", age: 21, cuteness: 10, softness: 10)
	Kitten.create!(name: "Snuffles", age: 6, cuteness: 9, softness: 7)
	Kitten.create!(name: "Fluffy", age: 14, cuteness: 5, softness: 9)
	Kitten.create!(name: "Dog", age: 11, cuteness: 3, softness: 2)
else
	5.times do
		Kitten.create!(name: "Filler Kitten ##{Kitten.count + 1}", age: rand(18), cuteness: rand(9) + 1, softness: rand(9) + 1)
	end
end