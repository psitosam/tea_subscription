class Customer < ApplicationRecord
  has_many :subscriptions
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP },
            :presence => { message: "can't be blank" },
            :uniqueness => true
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end 