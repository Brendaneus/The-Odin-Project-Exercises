class User < ApplicationRecord
	attr_accessor :remember_token

	validates :name, presence: true,
					 uniqueness: { case_sensitive: false },
					 length: { minimum: 4, maximum: 16 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true,
					  uniqueness: { case_sensitive: false },
					  format: { with: VALID_EMAIL_REGEX }
	has_secure_password

	before_create :remember

	has_many :posts

	def self.new_token
		SecureRandom.urlsafe_base64
	end

	def self.digest token
		Digest::SHA1.hexdigest(token)
	end

	def remember
		self.remember_token = User.new_token
		
		# Upon creation of a new object...
		unless User.find_by email: self.email
			# 'update_attribute' assigns to 'created_at' and 'updated_at' timestamps
			# 'update_attributes' does full save with validations and callbacks including 'before_create', as well as change timestamps
			# 'update_columns' skips validations and callbacks, but requires an existing record in the database
			self.remember_digest = User.digest(remember_token.to_s)
		else
			update_attribute( :remember_digest, User.digest(remember_token.to_s) )
		end
	end

	def forget
		self.remember_token = nil
		update_attribute( :remember_digest, nil )
	end
end
