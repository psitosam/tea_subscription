class Subscription < ApplicationRecord
  belongs_to :customer
  has_many :tea_subscriptions
  has_many :teas, through: :tea_subscriptions
  validates_presence_of :title
  validates_presence_of :price
  validates_presence_of :status
  validates_presence_of :frequency

  attribute :status, default: 0
  enum status: { active: 0, inactive: 1}
  enum frequency: { weekly: 0, bi_weekly: 1, monthly: 2 }
end 