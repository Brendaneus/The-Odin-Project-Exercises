# # Topics
#
# * modules
# * strings
#
# # Pig Latin
#
# Pig Latin is a made-up children's language that's intended to be confusing. It obeys a few simple rules (below) but when it's spoken quickly it's really difficult for non-children (and non-native speakers) to understand.
#
# Rule 1: If a word begins with a vowel sound, add an "ay" sound to the end of the word.
#
# Rule 2: If a word begins with a consonant sound, move it to the end of the word, and then add an "ay" sound to the end of the word.
#
# (There are a few more rules for edge cases, and there are regional variants too, but that should be enough to understand the tests.)
#
# See <http://en.wikipedia.org/wiki/Pig_latin> for more details.
#
#

require "pig_latin"

describe "#translate" do

  it "translates a word beginning with a vowel" do
    s = translate("apple")
    expect(s).to eq("appleay")
  end

  it "translates a word beginning with a consonant" do
    s = translate("banana")
    expect(s).to eq("ananabay")
  end

  it "translates a word beginning with two consonants" do
    s = translate("cherry")
    expect(s).to eq("errychay")
  end

  it "translates two words" do
    s = translate("eat pie")
    expect(s).to eq("eatay iepay")
  end

  it "translates a word beginning with three consonants" do
    expect(translate("three")).to eq("eethray")
  end

  it "counts 'sch' as a single phoneme" do
    s = translate("school")
    expect(s).to eq("oolschay")
  end

  it "counts 'qu' as a single phoneme" do
    s = translate("quiet")
    expect(s).to eq("ietquay")
  end

  it "counts 'qu' as a consonant even when it's preceded by a consonant" do
    s = translate("square")
    expect(s).to eq("aresquay")
  end

  it "translates many words" do
    s = translate("the quick brown fox")
    expect(s).to eq("ethay ickquay ownbray oxfay")
  end

  # Test-driving bonus:
  it "re-capitalizes capitalized words" do
    s = translate("John Smith")
    expect(s).to eq("Ohnjay Ithsmay")
  end

  it "perserves relative location and functionality of punctuation" do
    s = translate("'Whoms't hath bewritten this simple cipher?', I inquired.")
    expect(s).to eq("'Oms'twhay athhay ewrittenbay isthay implesay iphercay?', Iay inquireday.")
  end

end
