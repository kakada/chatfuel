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
    
    namespace :dashboard do
      # showcase
      resources :total_users, only: :index
      resources :total_users_accessed, only: :index
      resources :total_unique_users, only: :index

      # summary tab
      resources :total_visits, only: :index
      resources :total_feedbacks, only: :index

      # information access tab
      resources :most_requested_service_by_owso, only: :index
      resources :information_access_by_genders, only: :index
      resources :information_access_by_period, only: :index
      resources :most_popular_by_owso, only: :index
      resources :most_popular_by_period, only: :index
      resources :user_access, only: :index
      resources :ticket_tracking, only: :index
      resources :ticket_tracking_by_gender, only: :index
      
      # citizen feedback
      resources :total_feedback_by_gender, only: :index
      resources :owso_feedback_trend_by_period, only: :index
      resources :overall_rating_by_owso, only: :index
      resources :feedback_by_sub_categories, only: :index
    end

    get :home, to: "home#index"

    get "welcomes/filter"
    get "welcomes/q/access-info", to: "welcomes#access_info"
    get "welcomes/q/service-tracked", to: "welcomes#service_tracked"
    get "welcomes/q/feedback-trend", to: "welcomes#feedback_trend"
    get 'provincial-usages', to: 'provincial_usages#index'

    resources :users
    resources :tickets, only: [:index]
    resources :templates
    resources :quotas, only: [:index]

    # listview => show the whole frame
    # listview/showcase => only showcase detail
    # listview/summary => only summary tab
    # listview/summary?view=total-visit => only total visit in summary tab
    # listview/info-access?view=most-request[:bat],ticket-tracking
    # listview=citizen-feedback
    resources :listview, only: [:index], as: :listview do
      collection do
        get 'developer'
      end
    end

    # public static website
    get 'provinces', to: "provinces#index"
    get 'districts', to: "districts#index"

    resources :dictionaries, only: [:index, :new, :create, :edit, :update] do
      collection do
        post :set_most_request
        post :set_user_visit
        post :set_service_accessed
        post :set_criteria
      end
    end

    resources :pdf_templates
    get '/sites/:site_code/pdf_templates/:id/preview', to: 'sites/pdf_templates#show', as: :site_pdf_template_preview
    resources :schedules

    resources :sites do
      collection do
        get :new_import
        get :download
        post :import
      end

      scope module: :sites do
        resources :settings, only: [:index, :show, :create, :update]
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

      # Session
      resources :sessions, only: [:create] do
        collection do
          post "ivr", to: "sessions/ivr#create"
          # TODO: redundant path
          post "chatbot", to: "sessions/chatbot#create"
          post "chatbot/mark_as_completed", to: "sessions/chatbot#mark_as_completed"
          get  "chatbot/preview_map", to: "sessions/chatbot/map_preview#index", defaults: { locale: "km" }
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
    get 'sites/:site_code/map', to: 'sites#map', as: :site_map, defaults: { locale: "km" }

    resources :ivrs, only: [:create]
    resource :map_preview, only: [:show], defaults: { locale: 'km' }
    resources :chatbot_tracks, only: [:create]
    resources :ivr_tracks, only: [:create]
    resources :chatbots, only: [:create] do
      post :mark_as_completed, on: :collection
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      put :me, controller: "sites", action: "check"
      concerns :api_base
      resources :social_providers, only: [:create]
    end
  end

  mount Pumi::Engine => "/pumi"
end
