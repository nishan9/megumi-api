Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace "api" do
    namespace "v1" do
      resources :device_events do
        member do
          patch 'update-notification', to: 'device_events#update_notification', as: :update_notification
        end
      end
    end
  end
end
