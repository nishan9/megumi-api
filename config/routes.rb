# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace 'api' do
    namespace 'v1' do
      resources :device_events do
      end
      post 'device_events/export_events', to: 'device_events#export_events', as: :export_events
    end
  end
end
