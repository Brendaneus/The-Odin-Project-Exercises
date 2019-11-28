class Kitten < ApplicationRecord

	validates :name, presence: { message: "has to exist.  Who doesn't even give their cat a name?" },
					 uniqueness: { case_insensitive: true, message: "needs to be special.  Not everyone's cat can have the same name.  That would be chaos." },
					 length: { minimum: 2, maximum: 64, message: "should be of a reasonable length.  No one-letter names or anything that can't be pronounced in one breath." }
	
	validates :age, presence: { message: "is not only required here, but I hope for your sake, you are at least aware of, lest your feline-friend drops dead on the next outing" },
					numericality: { greater_than_or_equal_to: 0, less_than: 40, message: "has to be within a normal cat's lifetime, come on." }
	
	validates :cuteness, presence: { message: "is a factor all kitten-owners must assign with their best of judgement, and you just skipped that part." },
						 numericality: { greater_than: 0, less_than: 11, message: "should, of course, fall within the strict 1-10 guideline mandatory for all ratings systems." }

	validates :softness, presence: { message: "is on the list here, isn't it?" },
						 numericality: { greater_than: 0, less_than: 11, message: "must, like all fair ratings, be a choice of number from one to ten." }

end
