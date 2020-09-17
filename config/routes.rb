# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admins', as: 'rails_admin'
  devise_for :users, controllers: { passwords: 'users/passwords',
                                    sessions: 'users/sessions' }
  root 'buyers/home#index'

  resources :user_calendars do
    collection do
      get :new
    end
  end

  resources :users, only: [] do
    collection do
      get :email_inspection
      get :order_list
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

    resources :item_requests, only: %i[create destroy] do
      # collection not required id from resources
      collection do
        get :index
      end

      # member required id from resources
      member do
        get :progress, to: 'item_requests#progress', as: :progress
        get '/item_info/new', to: 'item_info#new', as: :item_info_new
        get '/item_info/edit', to: 'item_info#edit', as: :item_info_edit
        post '/item_info/create', to: 'item_info#create', as: :item_info_create
        patch '/item_info/update', to: 'item_info#update', as: :item_info_update

        get '/item_drawings/new', to: 'item_drawings#new', as: :item_drawings_new
        get '/item_drawings/edit', to: 'item_drawings#edit', as: :item_drawings_edit
        post '/item_drawings/create', to: 'item_drawings#create', as: :item_drawings_create
        post '/item_drawings/update', to: 'item_drawings#update', as: :item_drawings_update
        delete '/item_drawings/remove_file', to: 'item_drawings#remove_file', as: :item_drawings_remove_file

        get '/item_images/new', to: 'item_images#new', as: :item_images_new
        get '/item_images/edit', to: 'item_images#edit', as: :item_images_edit
        post '/item_images/create', to: 'item_images#create', as: :item_images_create
        post '/item_images/update', to: 'item_images#update', as: :item_images_update
      end
    end

    resources :list_buyer_suppliers, only: :index

    resources :item_qualities, only: %i[create update] do
      collection do
        get :new
        get :edit
      end
    end

    resources :item_samples, only: %i[create update] do
      collection do
        get :new
        get :edit
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
        get :edit
        get :send_mailer_quotation
      end
    end

    resources :imports do
      collection do
        get :download_csv
        post :suplier_id
      end
    end

    resources :catalogs, only: %i[index] do
    end
    resources :orders, only: %i[index] do
    end
    resources :claims, only: %i[index] do
      post :input
      get :table
      get :info
    end
    resources :samples, only: %i[index] do
    end
  end

  namespace :suppliers do
  end

  resources :buyers, only: [] do
    collection do
      get :search_supplier_import
      get :invite_unregisted_supplier
      post :send_email_invite
      get :register_item
      get :choose_provider
      get :search_provider
      post :sign_up
      get :confirm_email
      get :item_cost_down
      get :batch_items_selector
      get :demand_items_register
      get :batch_items_register
      get :status_inspect
    end
  end

  unless Rails.env.production?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
