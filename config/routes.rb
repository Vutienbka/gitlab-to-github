Rails.application.routes.draw do
  root 'home#index'
  root 'user#index'
  devise_for :users

  resources :users

  namespace :admins do
    root 'dashboard#index'
    resources :admins
  end
end
