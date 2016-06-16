Rails.application.routes.draw do

  resources :messages
  resources :meetups
  resources :testy3s

  devise_for :users
# devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  
  get 'home/index'
  root 'home#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
