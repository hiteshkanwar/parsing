Rails.application.routes.draw do

  get 'arrivals', to: 'parsing#arrivals', as: :arrivals
  get 'departures', to: 'parsing#departures', as: :departures
  root to: 'parsing#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
