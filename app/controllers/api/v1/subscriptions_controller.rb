class Api::V1::SubscriptionsController < ApplicationController

  before_action :get_info

  def index 
    if @customer != nil
      render json: CustomerSubscriptionsSerializer.new(@customer.subscriptions)
    else
      return invalid_request
    end 
  end 

  def create
    if params[:email].present?
      subscription = @customer.subscriptions.create(title: "#{@tea.title} Subscription for #{@customer.first_name}", price: params[:price], frequency: params[:frequency], customer_id: @customer.id)
      tea_sub = TeaSub.create(tea_id: @tea.id, subscription_id: subscription.id)
      if subscription.save
        render json: SubscriptionSerializer.new(subscription), status: 201
      else
        return invalid_request
      end 
    end 
  end 

  def update
    if params[:subscription_id].present?
      subscription = Subscription.find(params[:subscription_id])
      subscription.update(status: 1)
      if subscription.save
        render json: SubscriptionSerializer.new(subscription)
      end
    else
      return invalid_request
    end 
  end 
  # Right now the update endpoint only allows for changing a subscription from active to inactive.

  private

    def get_info
      @customer = Customer.find_by(email: params[:email])
      @tea = Tea.find_by(title: params[:tea_title])
    end 

    def invalid_request
      render json: { data: { message: 'Invalid Request' } }, status: 404
    end 
end 