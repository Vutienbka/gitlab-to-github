Rails.application.routes.draw do
  root 'home#index'
  root 'user#index'
  devise_for :users
  namespace :admins do
    root 'dashboard#index'
    resources :admins
  end
  
  # devise_scope :user do
  # end
  
  as :user do
    get '/signout', to: 'devise/sessions#destroy', as: :signout
    get 'signin' => 'devise/sessions#new'
    post 'signin' => 'devise/sessions#create'
    delete 'signout' => 'devise/sessions#destroy'
  end
end
