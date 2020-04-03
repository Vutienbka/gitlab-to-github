# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { passwords: 'users/passwords',
                                    sessions: 'users/sessions' }
  root 'buyers/home#index'

  resources :users, only: [] do
    collection do
      get :choose_provider
      get :email_register_item
      get :register_item
      get :search_provider
      get :sample_input
      get :batch_items_selector
      get :input_items_info
      get :input_items_drawing
      get :inspect_supplier
      get :email_inspection
      get :order_list
      get :batch_register
      get :cost_down_item
      get :status_inspect
      get :contract_form
    end
  end

  namespace :buyers do
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

    resources :profiles, only: [] do
      collection do
        get :edit
        patch :update
        get :set_account
        post :update_account
      end
    end

    resources :requests, only: %i[create] do
    end

    resources :item_requests, only: %i[create] do
    end

    resources :item_info, only: %i[create] do
      collection do
        get :new
      end
    end

    resources :item_quality, only: %i[create] do
      collection do
        get :new
      end
    end

    resources :item_drawings, only: %i[create] do
      collection do
        get :new
      end
    end

    resources :item_images, only: %i[create] do
      collection do
        get :new
      end
    end

    resources :item_standards, only: %i[create] do
      collection do
        get :new
      end
    end

    resources :inspection_requests, only: %i[create] do
      collection do
        get :new
      end
    end
    
    resources :item_conditions, only: %i[create] do
      collection do
        get :new
      end
    end
    resources :quotations do
      collection do
        get :new
        get :send_mailer_quotation
      end
    end
  end

  namespace :suppliers do
  end

  namespace :admin do
    root 'dashboard#index'
  end

  resources :buyers, only: [] do
    collection do
      get :invite_unregisted_supplier
      post :send_email_invite
      get :register_item
      get :choose_provider
      get :search_provider
      post :sign_up
      get :confirm_email
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' unless Rails.env.production?
end
