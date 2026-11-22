class FeedbackMessage < ApplicationRecord
  belongs_to :user, optional: true

  SUBJECTS = ["Питання щодо товару", "Підбір запчастин за VIN", "Статус замовлення",
              "Повернення та обмін", "Співпраця", "Інше"].freeze

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, inclusion: { in: SUBJECTS }
  validates :body, presence: true, length: { minimum: 10, maximum: 2000 }

  scope :recent, -> { order(created_at: :desc) }
end
