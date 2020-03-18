Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  root 'home#index'

  resources :users, only: [] do 
    collection do 
      get :choose_provider
      get :email_register_item
      get :email_register_supplier
      get :invite_form
      get :register_item
      get :search_provider
      get :sample_input
      get :batch_items_selector
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

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
