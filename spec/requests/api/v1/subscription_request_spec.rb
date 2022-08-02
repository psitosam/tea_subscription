require 'rails_helper'

RSpec.describe 'subscriptions requests' do

  it 'should return new subscription info and status 201' do 
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
  
end
