HeyPalFrontEnd::Application.routes.draw do
  if Rails.env.development?
    require 'preview_mails'
    mount PreviewMails => 'mail_view'
  end

  # Redirect http://squarestays.com to http://www.squarestays.com
  constraints(:host => /^squarestays.com/) do
    root :to => redirect("http://www.squarestays.com")
    match '/*path', :to => redirect {|params, request| "http://www.squarestays.com/#{params[:path]}"}
  end

  # Redirect http://squarestaY.com to http://www.squarestayS.com
  constraints(:host => /^(www.)?squarestay.dev/) do
    root :to => redirect("http://www.squarestays.com")
    match '/*path', :to => redirect {|params, request| "http://www.squarestays.com/#{params[:path]}"}
  end

  devise_for :users, :path => '/', :controllers => { :sessions => "sessions", :registrations => "registrations", :omniauth_callbacks => "omniauth_callbacks"},
             :path_names => { :sign_in => 'login', :sign_up => 'signup', :sign_out => 'logout' }

  # get   'search/index'
  match '/search'          => 'places#index', :as => :search
  match '/connect'         => 'users#connect'
  match '/cities'          => 'places#get_cities'
  match '/cities/suggest'  => 'home#suggest', :as => :city_suggest
  match '/:city'           => 'places#index', :city => Heypal::City.routes_regexp

  # SEO Routes
  match '/:city/:id'       => 'places#show', :city => Heypal::City.routes_regexp

  resources :places do
    member do
      get   :wizard
      get   :preview
      post  :upload_photo
      get   :photos
      put   :update_currency
      put   :publish
      put   :unpublish
      get   :publish_check
      get   :rent
      match :availability
      post  :confirm_inquiry
    end

    resources :photos, :only => [:create, :update, :destroy] do
      collection do
        put :sort
      end
    end

    get :search, :on => :collection

    resources :availabilities
    resources :comments do
      post :reply_to_message
    end
  end

  resources :transactions, :only => [:update]
  post 'paypal_callback', :to => 'payment_notifications#create'

  ###########################################################################################
  # Saved searches
  ###########################################################################################
  resources :alerts do
    get 'pause' => 'alerts#pause'
    get 'unpause' => 'alerts#unpause'
  end
  match '/search/code/:search_code' => 'alerts#show_search_code', :as => :show_search_code

  match '/my_places'          => 'places#my_places',          :as => :my_places
  match '/favorite_places'    => 'places#favorite_places',    :as => :favorite_places
  get   '/check_availability' => 'places#check_availability'

  ###########################################################################################
  # Messaging
  ###########################################################################################
  get    '/messages'                    => 'messages#index',                :as => :messages
  get    '/messages/:id'                => 'messages#conversation',         :as => :conversation
  post   '/messages/:id'                => 'messages#create',               :as => :new_message
  delete '/messages/:id'                => 'messages#delete_conversation',  :as => :delete_conversation
  get    '/messages/:id/mark_as_read'   => 'messages#mark_as_read',         :as => :mark_as_read
  get    '/messages/:id/mark_as_unread' => 'messages#mark_as_unread',       :as => :mark_as_unread

  ###########################################################################################
  # Profile
  ###########################################################################################
  match '/profile'      => 'users#show', :as => :profile
  match '/profile/edit' => 'users#edit', :as => :edit_profile

  put   'users/:id/change_preference' => "user#change_preference", :as => :change_preference
  match '/change_address'             => "addresses#update"
  match '/change_bank_account'        => "bank_accounts#update"
  put   '/change_password'            => "users#change_password"
  put   '/set_ref'                    => 'home#set_ref'

  ###########################################################################################
  # Static Content
  ###########################################################################################
  match '/why'                      => 'home#why',            :as => :home_why
  match '/how-it-works'             => 'home#how',            :as => :home_how
  match '/photography-faq'          => 'home#photo_faq',      :as => :home_photo_faq
  match '/terms'                    => 'home#terms'
  match '/fees'                     => 'home#fees'
  match '/privacy'                  => 'home#privacy'
  match '/contact'                  => 'home#contact'
  match 'city-guides/singapore'     => 'home#singapore',      :as => :cityguide_sg
  match 'city-guides/hong-kong'     => 'home#hongkong',       :as => :cityguide_hk
  match 'city-guides/kuala-lumpur'  => 'home#kualalumpur',    :as => :cityguide_kl

  root :to => 'home#index'

  ###########################################################################################
  # Backend ported resources
  ###########################################################################################
  resources :favorites, :only => [:create, :destroy]
  get 'favorites/add' => 'favorites#create' # For after login redirect

  ###########################################################################################
  # Detecting untranslated stringd
  ###########################################################################################
  if Rails.env.development?
    match 'translate'           => 'translate#index',     :as => :translate_list
    match 'translate/translate' => 'translate#translate', :as => :translate
    match 'translate/reload'    => 'translate#reload',    :as => :translate_reload
  end

  # Error matching
  # http://techoctave.com/c7/posts/36-rails-3-0-rescue-from-routing-error-solution
  get '/robots.txt' => 'home#robot'
  match '*a', :to => 'errors#routing'
end
