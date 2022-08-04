# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Customer.destroy_all
Subscription.destroy_all
Tea.destroy_all
TeaSub.destroy_all

customer_1 = Customer.create!(first_name: "Bill", last_name: "Hader", email: "testbill@testbill.test", address: "123 Bill Street")

tea_1 = Tea.create!(title: "Green", description: "Tasty green tea", temp: 100, brewtime: 6)
tea_2 = Tea.create!(title: "Black", description: "Tasty black tea", temp: 105, brewtime: 5)
tea_3 = Tea.create!(title: "Chamomile", description: "Bedtime tea", temp: 103, brewtime: 4)
tea_4 = Tea.create!(title: "Oolong", description: "Tasty oolong tea", temp: 102, brewtime: 3)

subscription_1 = customer_1.subscriptions.create!(title: "#{customer_1.first_name}'s Subscription for #{tea_1.title} tea", price: 10.0, status: 0, frequency: 1, customer_id: customer_1.id)

subscription_2 = customer_1.subscriptions.create!(title: "#{customer_1.first_name}'s Subscription for #{tea_2.title} tea", price: 11.0, status: 0, frequency: 2, customer_id: customer_1.id)

#Inactive subscription to check that it is returned in the request:
subscription_3 = customer_1.subscriptions.create!(title: "#{customer_1.first_name}'s Subscription for #{tea_3.title} tea", price: 14.0, status: 1, frequency: 2, customer_id: customer_1.id)

tea_sub_1 = TeaSub.create!(tea_id: tea_1.id, subscription_id: subscription_1.id)