def zero_prepend number
	(number < 10) ? "0" + number.to_s : number.to_s
end

puts "--> Seeding Users with 10 samples"

(1..10).each do |i|
	user = User.create(name: "Test User \##{zero_prepend(i)}", email: "test#{zero_prepend(i)}@example.com", password: "password", password_confirmation: "password")
end
