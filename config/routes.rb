Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      post '/subscriptions', to: 'subscriptions#create'
      patch '/subscriptions', to: 'subscriptions#update'
      get '/subscriptions', to: 'subscriptions#index'
    end 
  end 
end
