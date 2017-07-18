Rails.application.routes.draw do
  get 'checkin/index'
  
  resources :people
  
  root 'checkin#index'
end
