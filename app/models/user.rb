class User < ApplicationRecord
  has_secure_password

  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :feedback_messages, dependent: :nullify

  before_save { self.email = email.to_s.downcase.strip }

  validates :name, presence: true, length: { maximum: 60 }
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }
  validates :phone, format: { with: /\A\+?380\d{9}\z/, message: "має бути у форматі +380XXXXXXXXX" },
                    allow_blank: true
  validates :password, length: { minimum: 6 }, allow_nil: true
end
