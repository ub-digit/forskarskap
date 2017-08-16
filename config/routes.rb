Rails.application.routes.draw do
  get '/visits/new'
  
  resources :people, :path => 'stats'
  resources :visits

  
  root 'visits#new'
end
