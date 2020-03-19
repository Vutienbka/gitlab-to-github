Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'users/registrations', 
                                       :passwords => 'users/passwords',
                                       :sessions => 'users/sessions'}
  root 'buyer/home#index'

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

  namespace :buyer do
    resources :home, only: [] do
      collection do
        get :index
      end
    end
  
    resources :calendar do
      collection do
        get :show_calendar
      end
    end
    resources :setting do
      collection do
        get :index
      end
    end
  end

  namespace :supplier do
  end

  namespace :admin do
    root 'dashboard#index'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
