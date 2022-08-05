class CustomerSerializer
  include JSONAPI::Serializer 

  # set_id :id 
  # attributes :first_name,
  #            :last_name,
  #            :email,
  #            :address,
  #            :subscriptions

  def self.get_subscriptions(customer, subscriptions)
    {
      "data": {
        "type": "customer",
        "id": "#{customer.id}",
        "attributes": {
          "customer_name": "#{customer.first_name} #{customer.last_name}",
          "customer_email": "#{customer.email}",
          "customer_address": "#{customer.address}"
        },
        "subscriptions": subscriptions.map do |sub|
          {
            "subscription_id": "#{sub.id}",
            "tea": "#{sub.teas[0].title}",
            "subscription_price": "#{sub.price}",
            "subscription_freq": "#{sub.frequency}",
            "subscription_status": "#{sub.status}",
            "customer_id": "#{sub.customer_id}",
            "created_at": "#{sub.created_at}",
            "updated_at": "#{sub.updated_at}"
          }
        end
      }
    }
  end 
end 
