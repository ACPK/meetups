Rails.application.routes.draw do

  resources :messages
  resources :meetups
  
  devise_for :users
# devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  
  get 'home/index'
  root 'home#index'

  get 'positions/index' # TODO REMOVE THIS !!!
  
  get 'positions/users_for_current_positions'
  get 'positions/current_positions'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
