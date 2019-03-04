class Post < ApplicationRecord
	validates :user_id, presence: true
	validates :title, presence: true,
					  uniqueness: { case_sensitive: false },
					  length: { minimum: 4, maximum: 32 }
	validates :body, presence: true,
					  uniqueness: { case_sensitive: false },
					  length: { minimum: 4, maximum: 1024 }
	belongs_to :user
end
