Rails.application.routes.draw do

  devise_for :admins, controllers: {
    sessions: "admin/sessions",
    invitations: "admin/invitations"
  }

  devise_for :users, controllers: {
    registrations: "registrations", sessions: "sessions", confirmations: "confirmations",
    omniauth_callbacks: "omniauth_callbacks"
  }

  devise_scope :admin do
    get 'admins/sign_out' => "devise/sessions#destroy"
  end

  devise_scope :user do
    get 'users/sign_out' => "devise/sessions#destroy"
    get "registered", to: "registrations#confirmation_sent"
  end

  #errors
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#rejected"
  get "/500", to: "errors#internal_server_error"

  #public routes
  get "/pages/:page", to: "pages#show"
  resources :contact_email, only: [:create]
  resources :no_city_present, only: [:index]
  root to: "home#index"
  resources :auto_complete, only: [:index]
  resources :cities, only: [:index] do
    put "choose-city", to: "cities#choose_city"
  end
  resources :countries, only: [:index]
  resources :gallery, only: [:index]
  resources :reviews, only: [:index]
  resources :admin_notifications, only: [:create]

  get "presentation", to: "presentation#presentation"

  put "set_language", to: "languages#set_user_language"
  get "filter_cities", to: "locations#filter_cities"

  #authenticated user
  resources :users, only: [:edit, :update] do
    put "change_default_profile", to: "users#change_default_profile"
  end

  namespace :user do
    resources :photo_gallery
    resources :like_gallery, only: [:create, :destroy]
    resources :profile, only: [:index]
    resources :messages
    resources :inbox, only: [:index, :show]
    resources :invite_and_share, only: [:index]
    resources :notifications
    resources :reviews, only: [:new, :create, :index, :edit, :update]

    resources :quote_requests do
      member do
        put "decline_quote_request", to: "quote_requests#decline_quote_request"
      end
    end

    resources :follows do
      member do
        put "toggle", to: "follows#toggle"
      end
    end

    resources :favourites do
      member do
        put "toggle", to: "favourites#toggle"
      end
    end

    resources :businesses do
      put "claim_business", to: "businesses#claim_business"
    end

    resources :projects do
      get "filter_services", to: "project_steps#filter_services"
      get "set_category", to: "project_steps#set_category"

      resources :project_business, only: [:show]
      put "shortlist_business", to: "projects#shortlist_business"
      put "accept_quote", to: "projects#accept_quote"
      put "deny_quote", to: "projects#deny_quote"
      put "confirm_completion", to: "projects#confirm_completion"
      put "deny_completion", to: "projects#deny_completion"
      put "cancel_project", to: "projects#cancel_project_by_user"
      put "hide_business", to: "projects#hide_business"
      resources :photo_gallery
      resources :project_steps do
        member do
          put "skip", to: "project_steps#skip"
        end
      end
    end

  end

  namespace :business do
    put :switch_business, to: "switch_business#switch_business"

    resources :stats, only: [:index]
    resources :project_feed, only: [:index, :show]
    resources :inbox, only: [:index]
    resources :profile, only: [:index]
    resources :self_added_projects, only: [:edit, :update]
    resources :businesses, only: [:edit, :update] do
      put "switch_form_section", to: "businesses#switch_form_section"
      put "add_sub_categories", to: "businesses#add_sub_categories"
      delete "destroy_locations", to: "businesses#destroy_locations"
      delete "destroy_team_members", to: "businesses#destroy_team_members"
      delete "destroy_certifications", to: "businesses#destroy_certifications"
    end
    resources :favourites, only: [:index, :show]
    resources :user_callbacks, only: [:new, :create]
    resources :quotes do
      put "update_quote_status", to: "quotes#update_quote_status"
      put "download_as_zip", to: "quotes#download_as_zip"
    end
    resources :reviews, only: [:index, :show]
    resources :review_replies
    resources :notifications do
      collection do
        put "mark_as_read", to: "notifications#mark_as_read"
      end
    end
    resources :messages
    resources :projects, only: [:index, :show] do
      put "apply_to_project", to: "projects#apply_to_project"
      put "mark_as_complete", to: "projects#mark_as_complete"
      put "cancel_project", to: "projects#cancel_project_by_business"
      put "hide_project", to: "projects#hide_project"
    end
  end

  namespace :admin do
    root to: "overview#index"

    resources :overview, only: :index

    resource :statistics do
      get 'engagement'
      get 'businesses'
      get 'users'
      get 'categories'
      get 'analytics'
    end

    resource :gallery, only: [] do
      get 'business_banners'
      get 'user_projects'
      get 'business_projects'
      get 'business_logos'
      collection do
        delete 'destroy_video_link/:id', to: 'galleries#destroy_video_link'
        delete 'destroy_business_image/:image/:id', to: 'galleries#destroy_business_image'
        delete 'destroy_attachment/:image/:id', to: 'galleries#destroy_attachment'
        delete 'destroy_banner/:id', to: 'galleries#destroy_banner'
      end
    end

    resources :admin_notifications, only: [:show, :update] do
      collection do
        get 'site', to: 'admin_notifications#site'
        get 'business_claim', to: 'admin_notifications#business_claim'
        get 'inquiries', to: 'admin_notifications#inquiries'
        get 'upgrade', to: 'admin_notifications#upgrade'
        get 'new_businesses', to: 'admin_notifications#new_businesses'
        get 'new_projects', to: 'admin_notifications#new_projects'
        get 'new_reviews', to: 'admin_notifications#new_reviews'
        get 'new_callback_requests', to: 'admin_notifications#new_callback_requests'
      end
      member do
        put 'toggle_resolve'
      end
    end

    resources :admins do
      member do
        put 'enable'
        put 'disable'
      end
    end

    post 'select_country', to: 'base#select_country'

    resources :categories
    resources :sub_categories do
      member do
        put 'enable'
        put 'disable'
      end
    end
    resources :services do
      member do
        put 'enable'
        put 'disable'
      end
    end
    resources :cities do
      member do
        put 'enable'
        put 'disable'
      end
    end
    resources :reviews
    resources :review_replies
    resources :countries do
      member do
        put 'enable'
        put 'disable'
      end
    end

    resources :subscriptions do
      get 'send_invoice'
      get 'send_receipt'
    end

    resources :businesses do
      collection do
        put 'delete_photo', to: 'businesses#delete_photo'
      end

      member do
        put 'enable'
        put 'disable'
        put 'dissociate_owner'
        put 'clear_business_hours'
      end
    end

    resources :vendors do
      resources :subscriptions
      member do
        put 'enable'
        put 'disable'
      end
    end

    resources :users do
      member do
        put 'enable'
        put 'disable'
      end
    end

    resources :projects

    resources :project_types

    resources :verifications
    resources :certifications
    resources :banners, except: :index do
      collection do
        get 'sidebar', to: 'banners#sidebar'
        get 'dashboard', to: 'banners#dashboard'
        get 'listing', to: 'banners#listing'
      end
      put 'enable'
      put 'disable'
    end
  end

  scope path: '(:city)' do
    root to: "home#index"
    resources :self_added_projects, only: [:index]
    resources :businesses do
      put "flag_business", to: "businesses#flag_business"
      collection do
        put "website_view", to: "businesses#website_view"
        put "social_view", to: "businesses#social_view"
        put "number_view", to: "businesses#number_view"
        put "project_view", to: "businesses#project_view"
      end
    end
    resources :listing_map, only: [:index]
    resources :categories, only: [:index, :show]
    resources :sub_categories, only: [:index, :show]
    resources :services, only: [:index, :show]
  end

end
