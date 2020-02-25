Rails.application.routes.draw do
  namespace :admins do
    root 'dashboard#index'
    resources :admins
  end
end
