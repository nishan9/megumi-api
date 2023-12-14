Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace "api" do
    namespace "v1" do
      resources :device_events do
        member do
          patch 'update-notification', to: 'device_events#update_notification', as: :update_notification
        end
      end

      get 'device_events/:id', to: 'device_events#show', as: :show_device_event
      get 'device_events', to: 'device_events#index', as: :all_device_events
    end
  end
end
