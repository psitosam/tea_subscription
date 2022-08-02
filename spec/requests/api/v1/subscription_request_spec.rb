require 'rails_helper'

RSpec.describe 'subscriptions requests' do

  it 'creates a subscription for a customer' do 
    describe 'happy path' do 
      it 'should return new subscription info and status 201' do 
        # customer = Customer.create!(first_name: 'Usain', last_name: 'Bolt', email: 'test@test.com', address: '1234 Test Ave.')
        customer = create :customer
        tea = create :tea 
        subscription_params = {
          title: "#{customer.first_name}'s Subscription to #{tea.title}",
          price: ""
        }
      end 
    end 
  end 
  
end
