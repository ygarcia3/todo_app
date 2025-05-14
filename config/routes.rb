Rails.application.routes.draw do
  get "dashboard/index"
  resources :categories
  
  # ✅ Combine todos routes with the custom completed action
  resources :todos do
    collection do
      get :completed
    end
    member do
      patch :toggle_complete
    end
    
  end

  devise_for :users
  
  root to: "dashboard#index"

  # Optional health and PWA endpoints
  get "up" => "rails/health#show", as: :rails_health_check
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
