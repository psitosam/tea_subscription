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

  describe 'the index endpoint' do 
    before :each do 
      @customer = create :customer
      @tea_1 = create(:tea, brewtime: "00:11:00") 
      @tea_2 = create(:tea, brewtime: "00:12:00") 
      @tea_3 = create(:tea, brewtime: "00:13:00") 
      # active subscription 1
      @subscription_1 = @customer.subscriptions.create!(title: "#{@tea_1.title} Subscription for {@customer.first_name}", price: 12.5, status: 0, frequency: 1)
      @tea_sub_1 = TeaSub.create!(tea_id: @tea_1.id, subscription_id: @subscription_1.id)
      # inactive subscription 2 
      @subscription_2 = @customer.subscriptions.create!(title: "#{@tea_2.title} Subscription for {@customer.first_name}", price: 12.5, status: 1, frequency: 1)
      @tea_sub_2 = TeaSub.create!(tea_id: @tea_2.id, subscription_id: @subscription_2.id)
      # active subscription 3
      @subscription_3 = @customer.subscriptions.create!(title: "#{@tea_3.title} Subscription for {@customer.first_name}", price: 12.5, status: 0, frequency: 1)
      tea_sub_3 = TeaSub.create!(tea_id: @tea_3.id, subscription_id: @subscription_3.id)
    end 
    
    it 'happy path for index action returns all subscriptions regardless of status' do 

      payload = {
        email: @customer.email
      }
      headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

      get '/api/v1/subscriptions', headers: headers, params: payload

      reply = JSON.parse(response.body, symbolize_names: true)

      expect(reply).to have_key :data 
      expect(reply[:data]).to be_a Hash 
      expect(reply[:data]).to have_key :id 
      expect(reply[:data]).to have_key :type
      expect(reply[:data]).to have_key :attributes
      expect(reply[:data][:type]).to eq("customer")
      expect(reply[:data][:attributes]).to be_a Hash
      expect(reply[:data][:attributes]).to have_key :first_name
      expect(reply[:data][:attributes]).to have_key :last_name
      expect(reply[:data][:attributes]).to have_key :email
      expect(reply[:data][:attributes]).to have_key :address
      expect(reply[:data][:attributes]).to have_key :subscriptions
      expect(reply[:data][:attributes][:subscriptions]).to be_a Array
      reply[:data][:attributes][:subscriptions].each do |sub|
        expect(sub).to have_key :id
        expect(sub).to have_key :title
        expect(sub).to have_key :price
        expect(sub).to have_key :status
        expect(sub).to have_key :frequency
        expect(sub).to have_key :customer_id
        expect(sub).to have_key :created_at
        expect(sub).to have_key :updated_at
      end 
    end

    it 'sad path returns error message and 404' do 

      payload = {
        email: @customer.first_name
      }
      headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

      get '/api/v1/subscriptions', headers: headers, params: payload

      reply = JSON.parse(response.body, symbolize_names: true)
      
      expect(reply).to have_key :data
      expect(reply[:data]).to be_a Hash
      expect(reply[:data]).to have_key :message
      expect(reply[:data][:message]).to eq("Invalid Request")
    end 
  end  
end