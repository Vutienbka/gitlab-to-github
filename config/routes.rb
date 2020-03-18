Rails.application.routes.draw do
  root 'home#index'
  root 'user#index'
  devise_for :users

  resources :users, only: [] do 
    collection do 
      get :choose_provider
      get :email_register_item
      get :email_register_supplier
      get :invite_form
      get :register_item
      get :search_provider
    end 
  end

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
