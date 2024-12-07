# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :reports, only: [:index] do 
    collection do
      post :generate
    end
  end

  mount Sidekiq::Web => '/sidekiq'
  resources :proponents do
    collection do
      post :calculate_discount
      get :report
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount ActionCable.server => '/cable'

  # Defines the root path route ("/")
  root "proponents#index"
end
