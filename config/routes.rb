# frozen_string_literal: true

require "sidekiq/web"
require_relative "whitelist"

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  guisso_for :user

  authenticate :user, ->(user) { user.system_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  scope "(:locale)", locale: /en|km/ do
    root "welcomes#index"
    get :dashboard, to: "dashboard#show"
    get :home, to: "home#index"

    resources :users
    resources :tickets, only: [:index]
    resources :templates
    resources :quotas, only: [:index]
    resource  :welcome, only: [:index, :show]
    resources :dictionaries, only: [:index, :new, :create, :edit, :update] do
      collection do
        post :set_most_request
        post :set_user_visit
        post :set_service_accessed
        post :set_criteria
      end
    end

    resources :sites do
      collection do
        get :new_import
        get :download
        post :import
      end

      scope module: :sites do
        resource :setting, only: [:show, :create, :update]
        resource :api_key
      end
    end

    resources :settings, only: [:index] do
      collection do
        put :telegram_bot
        get :help
      end
    end
  end

  constraints Whitelist.new do
    resource :manifest, only: [:show], defaults: { format: "xml" }

    namespace :bots do
      # Message
      resources :messages, only: [:create] do
        collection do
          post :mark_as_completed
          post "ivr", to: "messages/ivr#create"
          post "chatbot", to: "messages/chatbot#create"
          get  "chatbot/preview_map", to: "messages/map_preview#index", defaults: { locale: "km" }
        end
      end

      # Track
      resources :tracks, only: [:create] do
        collection do
          post "ivr", to: "tracks/ivr#create"
          post "chatbot", to: "tracks/chatbot#create"
        end
      end
    end
  end

  # Telegram
  telegram_webhook TelegramWebhooksController
  concern :api_base do
    resources :sites, param: :site_code, only: [:update]
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      put :me, controller: "sites", action: "check"
      concerns :api_base
    end
  end

  mount Pumi::Engine => "/pumi"
end
