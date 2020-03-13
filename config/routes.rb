Rails.application.routes.draw do
  root 'home#index'
  root 'user#index'
  devise_for :users

  resources :users

  resources :home, only: [] do
    collection do
      get :show_calendar
    end
  end

  namespace :admins do
    root 'dashboard#index'
    resources :admins
  end
end
