Rails.application.routes.draw do
  get '/visits/new'
  
  resources :people
  resources :visits

  
  root 'visits#new'
end
