class User < ApplicationRecord
  has_secure_password

  has_many :favourites, dependent: :destroy
  has_many :properties, through: :favourites

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }
  validates :role, inclusion: { in: %w[buyer admin] }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
