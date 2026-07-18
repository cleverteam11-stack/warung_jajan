Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "products#index"
  resources :products, only: [ :index, :show ], param: :slug

  resource :cart, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ], param: :product_id

  resources :orders, only: [ :new, :create, :show ], param: :number

  namespace :admin do
    root "dashboard#index"
    resources :products
    resources :categories
    resources :orders, only: [ :index, :show, :update ]
  end
end
