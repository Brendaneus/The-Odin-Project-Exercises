require './lib/enumerable_methods'

RSpec.describe Enumerable do
	describe "#my_each" do
		it "handles arrays" do
			string = ''
			['a', 'b', 'c'].my_each { |x| string += ':' + x }
			expect(string).to eql(':a:b:c')
		end

		it "handles hashes" do
			string = ''
			{a: 'a', b: 'b', c: 'c'}.my_each { |x,y| string += ':' + y }
			expect(string).to eql(':a:b:c')
		end

		it "returns self" do
			sum = 0
			expect([1,2,3].my_each { |x| sum += x }).to eql([1,2,3])
			expect({a: 1,b: 2,c: 3}.my_each { |x,y| sum += y }).to eql({a: 1,b: 2,c: 3})
		end

		it "handles empty arrays and hashes" do
			string = ''
			[].my_each { |x| string += ':' + x }
			{}.my_each { |x,y| string += ':' + y }
			expect(string).to eql('')
		end
	end

	describe "#my_select" do
		it "handles arrays" do
			expect(['a', 'b', 'c'].my_select { |x| x == 'b' }).to eql(['b'])
		end

		it "handles hashes" do
			expect({a: 'a', b: 'b', c: 'c'}.my_select { |x,y| y == 'b' }).to eql({b: 'b'})
		end

		it "handles empty arrays and hashes" do
			expect([].my_each { |x| x }).to eql([])
			expect({}.my_each { |x,y| y }).to eql({})
		end
	end

	describe "#my_any?" do
		it "handles arrays" do
			expect(['a', 'b', 'c'].my_any? { |x| x == 'b' }).to eql(true)
		end

		it "handles hashes" do
			expect({a: 'a', b: 'b', c: 'c'}.my_any? { |x,y| y == 'b' }).to eql(true)
		end

		it "handles empty arrays and hashes" do
			expect([].my_any? { |x| x }).to eql(false)
			expect({}.my_any? { |x,y| y }).to eql(false)
		end
	end

	describe "#my_count" do
		it "handles arrays" do
			expect(['a', 'b', 'c'].my_count).to eql(3)
		end

		it "handles hashes" do
			expect({a: 'a', b: 'b', c: 'c'}.my_count).to eql(3)
		end

		it "handles empty arrays and hashes" do
			expect([].my_count).to eql(0)
			expect({}.my_count).to eql(0)
		end

		it "handles arguments" do
			expect(['a','b','c'].my_count('b')).to eql(1)
			expect({a: 'a', b: 'b', c: 'c'}.my_count([:b,'b'])).to eql(1)
		end

		it "handles blocks" do
			expect(['a','b','c'].my_count { |x| x == 'b' }).to eql(1)
			expect({a: 'a', b: 'b', c: 'c'}.my_count { |x,y| y == 'b' }).to eql(1)
		end

		# change method and tests to reflect error throwing support
		it "throws error (changed to -1) when both argument and block passed" do
			expect(['a','b','c'].my_count('b') { |x| x == 'b' }).to eql(-1)
			expect({a: 'a', b: 'b', c: 'c'}.my_count([:b, 'b']) { |x,y| y == 'b' }).to eql(-1)
		end
	end

	describe "#map" do
		it "handles arrays" do
			expect(['a', 'b', 'c'].my_map {|x| x + 'yo' }).to eql(['ayo', 'byo', 'cyo'])
		end

		it "handles hashes" do
			expect({a: 'a', b: 'b', c: 'c'}.my_map { |x,y| y + 'yo' }).to eql({a: 'ayo', b: 'byo', c: 'cyo'})
		end

		it "handles empty arrays and hashes" do
			expect([].my_map { |x| x }).to eql([])
			expect({}.my_map { |x,y| y }).to eql({})
		end

		it "handles [proc] arguments" do
			my_arr_proc = Proc.new {|x| x * x}
			my_hash_proc = Proc.new {|x,y| y * y}
			expect([1,2,3].my_map(my_arr_proc)).to eql([1, 4, 9])
			expect({a: 1, b: 2, c: 3}.my_map(my_hash_proc)).to eql({a: 1, b: 4, c: 9})
		end

		it "handles blocks" do
			expect([1,2,3].my_map { |x| x * x }).to eql([1, 4, 9])
			expect({a: 1, b: 2, c: 3}.my_map { |x,y| y * y }).to eql({a: 1, b: 4, c: 9})
		end
	end

	describe "#my_inject" do
		it "handles arrays" do
			expect([1, 2, 3].my_inject { |total, x| total += x }).to eql(6)
		end

		it "handles hashes" do
			expect({a: 1, b: 2, c: 3}.my_inject { |total, x| total += x }).to eql(6)
		end

		it "handles one argument (symbolized method)" do
			expect([1,2,3].my_inject(:+)).to eql(6)
			expect({a: 1, b: 2, c: 3}.my_inject(:+)).to eql(6)
		end

		it "handles two arguments (symbolized method and base total)" do
			expect([1,2,3].my_inject(10, :+)).to eql(16)
			expect({a: 1, b: 2, c: 3}.my_inject(10, :+)).to eql(16)
		end

		it "handles one argument (base total) and block" do
			expect([1, 2, 3].my_inject(10) { |total, x| total += x }).to eql(16)
			expect({a: 1, b: 2, c: 3}.my_inject(10) { |total, x| total += x }).to eql(16)
		end
	end
end
