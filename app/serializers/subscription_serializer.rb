class SubscriptionSerializer
  include JSONAPI::Serializer 

  set_id :id
  set_type :subscription
  attributes :title,
             :price,
             :status,
             :frequency
  
  attribute :tea_ids do |object|
    object.tea_ids
  end
  
end 