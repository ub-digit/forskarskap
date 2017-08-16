Rails.application.routes.draw do
  get '/visits/new'
  
  resources :people, :path => 'info'
  resources :visits

  
  root 'visits#new'
end
