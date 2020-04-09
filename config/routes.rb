# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admins', as: 'rails_admin'
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
        get :new
        post :create
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

    resources :item_info, only: %i[create update] do
      collection do
        get :new
        get :edit
      end
    end

    resources :item_qualities, only: %i[create update] do
      collection do
        get :new
        get :edit
      end
    end

    resources :item_drawings, only: %i[create update] do
      collection do
        get :new
        get :edit
      end
      resources :draw_categories, only: [] do
        resources :file_draws, only: %i[create destroy]
      end
    end

    resources :item_images, only: %i[create update] do
      collection do
        get :new
        get :edit
      end
      resources :image_categories, only: [] do
        resources :file_images, only: %i[create destroy]
      end
    end

    resources :item_standards, only: %i[create update] do
      collection do
        get :new
        get :edit
      end
      resources :standard_categories, only: [] do
        resources :file_standards, only: %i[create destroy]
      end
    end

    resources :inspection_requests, only: %i[create] do
      collection do
        get :new
      end
    end
    
    resources :item_conditions, only: %i[create update] do
      collection do
        get :new
        get :edit
        delete :destroy_condition
      end
    end
    resources :item_quotations do
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
      get :sample_input
      get :item_cost_down
      get :batch_items_selector
      get :demand_items_register
      get :batch_items_register
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' unless Rails.env.production?
end
