Rails.application.routes.draw do
  get 'checkin/index'
  
  resources :people do
    resources :visits
  end
  
  root 'checkin#index'
end
