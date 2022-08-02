require 'rails_helper'

RSpec.describe 'subscriptions requests' do

  it 'create happy path returns new subscription info and status 201' do 
    customer = create :customer
    tea = create(:tea, brewtime: "00:12:00") 
    frequency = 1
    price = 10.0
    subscription_params = {
      email: customer.email,
      tea_title: tea.title,
      frequency: frequency,
      price: price
    }
    headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
    post '/api/v1/subscriptions', headers: headers, params: JSON.generate(subscription_params)

    subscription = JSON.parse(response.body, symbolize_names: true)
    
    expect(response.status).to eq 201
    expect(subscription).to have_key :data
    expect(subscription[:data]).to be_a Hash
    expect(subscription[:data]).to have_key :id 
    expect(subscription[:data]).to have_key :type 
    expect(subscription[:data][:type]).to eq("subscription")
    expect(subscription[:data]).to have_key :attributes 
    expect(subscription[:data][:attributes]).to have_key :title 
    expect(subscription[:data][:attributes][:title]).to eq("#{tea.title} Subscription for #{customer.first_name}")
    expect(subscription[:data][:attributes]).to have_key :price
    expect(subscription[:data][:attributes][:price]).to eq(subscription_params[:price])
    expect(subscription[:data][:attributes]).to have_key :status
    expect(subscription[:data][:attributes][:status]).to eq("active")
    expect(subscription[:data][:attributes]).to have_key :frequency
    expect(subscription[:data][:attributes][:frequency]).to eq("bi_weekly")
  end 

  it 'create sad path returns 404 if not given valid data' do 
    # here we are leaving out frequency information which should cause the subscription to not be created on line 17 of the Controller.
    customer = create :customer
    tea = create(:tea, brewtime: "00:14:00")
    price = 10.0
    subscription_params = {
      email: customer.email,
      tea_title: tea.title,
      price: price
    }
    headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
    post '/api/v1/subscriptions', headers: headers, params: JSON.generate(subscription_params)
    
    subscription = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 404
    expect(subscription).to have_key :data
    expect(subscription[:data]).to have_key :message
    expect(subscription[:data][:message]).to eq("Invalid Request")
  end 

  it 'happy path for update returns canceled subscription' do 

    customer = create :customer
    tea = create(:tea, brewtime: "00:11:00") 
    subscription = customer.subscriptions.create!(title: "#{tea.title} Subscription for #{customer.first_name}", price: 12.5, status: 0, frequency: 1)
    tea_sub = TeaSub.create!(tea_id: tea.id, subscription_id: subscription.id)
    payload = {
      subscription_id: subscription.id    
    }
    headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
    patch '/api/v1/subscriptions', headers: headers, params: JSON.generate(payload)

    subscription = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    expect(subscription).to have_key :data 
    expect(subscription[:data]).to be_a Hash 
    expect(subscription[:data]).to have_key :type 
    expect(subscription[:data][:type]).to eq("subscription")
    expect(subscription[:data]).to have_key :attributes
    expect(subscription[:data][:attributes]).to have_key :title 
    expect(subscription[:data][:attributes][:title]).to eq("#{tea.title} Subscription for #{customer.first_name}")
    expect(subscription[:data][:attributes]).to have_key :price
    expect(subscription[:data][:attributes]).to have_key :status
    expect(subscription[:data][:attributes][:status]).to eq("inactive")
  end 

  it 'sad path for update returns invalid request' do 
    customer = create :customer
    tea = create(:tea, brewtime: "00:11:00") 
    subscription = customer.subscriptions.create!(title: "#{tea.title} Subscription for #{customer.first_name}", price: 12.5, status: 0, frequency: 1)
    tea_sub = TeaSub.create!(tea_id: tea.id, subscription_id: subscription.id)
    payload = {
      email: customer.email    
    }
    headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
    patch '/api/v1/subscriptions', headers: headers, params: JSON.generate(payload)

    reply = JSON.parse(response.body, symbolize_names: true)
    
    expect(response.status).to eq 404
    expect(reply).to have_key :data 
    expect(reply[:data]).to have_key :message
    expect(reply[:data][:message]).to eq("Invalid Request")
  end 
  
end
