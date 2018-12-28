require './lib/caesar_cipher'

RSpec.describe '#caesar_cipher' do
	# add nil string handling?
	it "handles empty strings" do
		expect(caesar_cipher("", 5)).to eql("")
	end

	it "shifts by zero" do
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", 0)).to eql("the quick brown fox jumps over the lazy dog")
	end

	it "shifts phrases up by variable letters" do
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", 5)).to eql("ymj vznhp gwtbs ktc ozrux tajw ymj qfed itl")
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", 25)).to eql("sgd pthbj aqnvm enw itlor nudq sgd kzyx cnf")
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", 26)).to eql("the quick brown fox jumps over the lazy dog")
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", 111)).to eql("aol xbpjr iyvdu mve qbtwz vcly aol shgf kvn")
	end

	it "shifts phrases down by variable letters" do
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", -5)).to eql("ocz lpdxf wmjri ajs ephkn jqzm ocz gvut yjb")
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", -25)).to eql("uif rvjdl cspxo gpy kvnqt pwfs uif mbaz eph")
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", -26)).to eql("the quick brown fox jumps over the lazy dog")
		expect(caesar_cipher("the quick brown fox jumps over the lazy dog", -111)).to eql("max jnbvd ukhpg yhq cnfil hoxk max etsr whz")
	end

	it "handles capital and lower cases" do
		expect(caesar_cipher("CrAzY LeTtErS", 0)).to eql("CrAzY LeTtErS")
		expect(caesar_cipher("CrAzY LeTtErS", 5)).to eql("HwFeD QjYyJwX")
		expect(caesar_cipher("CrAzY LeTtErS", 25)).to eql("BqZyX KdSsDqR")
		expect(caesar_cipher("CrAzY LeTtErS", 111)).to eql("JyHgF SlAaLyZ")
	end

	it "handles non-letter and escaped characters" do
		expect(caesar_cipher("Sentence with \"non-letter\" words; [an] example of extraneous (eg. '*') characters.", 0)).to eql("Sentence with \"non-letter\" words; [an] example of extraneous (eg. '*') characters.")
		expect(caesar_cipher("Sentence with \"non-letter\" words; [an] example of extraneous (eg. '*') characters.", 5)).to eql("Xjsyjshj bnym \"sts-qjyyjw\" btwix; [fs] jcfruqj tk jcywfsjtzx (jl. '*') hmfwfhyjwx.")
		expect(caesar_cipher("Sentence with \"non-letter\" words; [an] example of extraneous (eg. '*') characters.", 25)).to eql("Rdmsdmbd vhsg \"mnm-kdssdq\" vnqcr; [zm] dwzlokd ne dwsqzmdntr (df. '*') bgzqzbsdqr.")
		expect(caesar_cipher("Sentence with \"non-letter\" words; [an] example of extraneous (eg. '*') characters.", 111)).to eql("Zlualujl dpao \"uvu-slaaly\" dvykz; [hu] lehtwsl vm leayhulvbz (ln. '*') johyhjalyz.")
	end
end
