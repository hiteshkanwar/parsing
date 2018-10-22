Rails.application.routes.draw do

  get 'arrivals', to: 'parsing#arrivals', as: :arrivals
  get 'departures', to: 'parsing#departures', as: :departures

  # get 'search_arrivals_by', to: 'parsing#search_arrivals_by', as: :search_arrivals_by
  # get 'search_departures_by', to: 'parsing#search_departures_by', as: :search_departures_by
  
  root to: 'parsing#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'arrivals', to: 'parsing#arrivals', via: [:get, :post]
      match 'departures', to: 'parsing#departures', via: [:get, :post]
    end
  end
end
