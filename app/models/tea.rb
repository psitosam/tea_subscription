class Tea < ApplicationRecord
  has_many :tea_subs
  has_many :subscriptions, through: :tea_subs
  # has_many :customers, through: :subscriptions
end 