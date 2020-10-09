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
        post :private_contract
      end
      # member required id from resources
      member do
        get :private_contract_progress, to: 'item_requests#private_contract_progress', as: :private_contract_progress
        get :progress, to: 'item_requests#progress', as: :progress
        get '/item_info/new', to: 'item_info#new', as: :item_info_new
        get '/item_info/edit', to: 'item_info#edit', as: :item_info_edit
        post '/item_info/create', to: 'item_info#create', as: :item_info_create
        patch '/item_info/update', to: 'item_info#update', as: :item_info_update
        get '/item_info/sub_category/:catalog_id', to: 'item_info#sub_category', as: :item_info_sub_category
        get '/item_info/child_category/:catalog_id', to: 'item_info#child_category', as: :item_info_child_category

        get '/item_drawings/new', to: 'item_drawings#new', as: :item_drawings_new
        get '/item_drawings/edit', to: 'item_drawings#edit', as: :item_drawings_edit
        post '/item_drawings/create', to: 'item_drawings#create', as: :item_drawings_create
        post '/item_drawings/update', to: 'item_drawings#update', as: :item_drawings_update
        delete '/item_drawings/remove_file', to: 'item_drawings#remove_file', as: :item_drawings_remove_file

        get '/item_images/new', to: 'item_images#new', as: :item_images_new
        get '/item_images/edit', to: 'item_images#edit', as: :item_images_edit
        post '/item_images/create', to: 'item_images#create', as: :item_images_create
        post '/item_images/update', to: 'item_images#update', as: :item_images_update
        delete '/item_images/remove_file', to: 'item_images#remove_file', as: :item_images_remove_file

        get '/item_qualities/new', to: 'item_qualities#new', as: :item_qualities_new
        get '/item_qualities/edit', to: 'item_qualities#edit', as: :item_qualities_edit
        post '/item_qualities/create', to: 'item_qualities#create', as: :item_qualities_create
        patch '/item_qualities/update', to: 'item_qualities#update', as: :item_qualities_update

        get '/item_standards/new', to: 'item_standards#new', as: :item_standards_new
        get '/item_standards/edit', to: 'item_standards#edit', as: :item_standards_edit
        post '/item_standards/create', to: 'item_standards#create', as: :item_standards_create
        post '/item_standards/update', to: 'item_standards#update', as: :item_standards_update
        delete '/item_standards/remove_file', to: 'item_standards#remove_file', as: :item_standards_remove_file

        get '/item_conditions/new', to: 'item_conditions#new', as: :item_conditions_new
        get '/item_conditions/edit', to: 'item_conditions#edit', as: :item_conditions_edit
        post '/item_conditions/create', to: 'item_conditions#create', as: :item_conditions_create
        post '/item_conditions/update', to: 'item_conditions#update', as: :item_conditions_update
        get '/item_conditions/company_info', to: 'item_conditions#company_info', as: :item_conditions_company_info

        get '/complete', to: 'item_requests#complete', as: :complete
        post :submitted
      end
    end

    resources :list_buyer_suppliers, only: :index

    resources :inspection_requests, only: %i[create] do
      collection do
        get :new
        get :complete_credit_registration
      end
    end

    resources :imports do
      collection do
        get :download_csv
        post :suplier_id
      end
    end

    resources :catalogs, only: %i[index new create update destroy] do
      collection do
        get :index
        get :get_selected_catalog
        get :get_catalog_after_click
      end
        resources :sub_catalogs, only: %i[index new create update destroy] do
          collection do
            get :get_selected_sub_catalog
          end
          resources :grandchild_catalogs, only: %i[index new create update destroy] do
            collection do
              get :get_selected_grandchild_catalog
            end
          end
      end
      resources :catalog_items, only: %i[index]
    end

    resources :searchs do
      collection do
      get :search
      post :list_auto
      end
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
      get :complete_introduce
      post :send_email_invite
      get :register_item
      get :choose_provider
      get :search_provider
      post :sign_up
      get :confirm_email
      get :item_cost_down
      get :batch_items_selector
      get :batch_items_selector_csv
      get :demand_items_register
      get :batch_items_register
      get :status_inspect
      get :round_throw
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' unless Rails.env.production?
end
