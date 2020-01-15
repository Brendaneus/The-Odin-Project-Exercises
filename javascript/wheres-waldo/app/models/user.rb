class User < ApplicationRecord
  has_many :scores, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  has_secure_password
  validate :none_or_both_passwords

  def new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticates? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

    def none_or_both_passwords
      if password.present? && password_confirmation.nil?
        errors.add(:password_confirmation, "must be present to confirm")
      end
    end
end
