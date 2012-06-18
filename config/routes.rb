HeyPalFrontEnd::Application.routes.draw do
  get 'sitemap.xml' => 'cached_sitemaps#sitemap'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

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

  root :to => 'home#index'

  devise_for :users,
             :controllers => { :sessions => 'sessions',
                               :registrations => 'registrations',
                               :passwords => 'passwords',
                               :omniauth_callbacks => "omniauth_callbacks"},
             :path_names => {  :sign_in => 'login',
                               :sign_up => 'signup',
                               :sign_out => 'logout' }

  resources :places do
    member do
      get   :wizard
      get   :preview
      put   :update_currency
      put   :publish
      put   :unpublish
      get   :publish_check
      match :availability
    end
    resources :photos, :only => [:create, :update, :destroy] do
      collection do
        put :sort
      end
    end

    resources :comments do
      post :reply_to_message
    end
  end

  match '/my_places'          => 'places#index',              :as => :my_places


  ###########################################################################################
  # Saved searches
  ###########################################################################################
  resources :alerts do
    get 'pause' => 'alerts#pause'
    get 'unpause' => 'alerts#unpause'
  end
  match '/search/code/:search_code' => 'alerts#show_search_code', :as => :show_search_code

  ###########################################################################################
  # Inquiries
  ###########################################################################################
  resources :messages do
    member do
      put :mark_as_unread
    end
  end

  resources :inquiries, :only => [:create]
  resources :transactions, :only => [:update]
  post 'paypal_callback', :to => 'payment_notifications#create', :as => :paypal_callback

  ###########################################################################################
  # Profiles
  ###########################################################################################
  resource :profile

  resources :users, :only => [:show]

  put   '/set_ref'                    => 'home#set_ref'

  ###########################################################################################
  # Backend ported resources
  ###########################################################################################
  resources :favorites, :only => [:create, :destroy]
  get 'favorites/add' => 'favorites#create' # For after login redirect

  resources :search, :controller => 'Search', :only => [:index, :show] do
    collection do
      get :favorites
    end
  end

  match '/connect'         => 'users#connect'
  match '/cities'          => 'places#get_cities'
  resources :feedbacks, :only => [:create]
  match '/:city'           => 'search#index', :city => City.routes_regexp

  # SEO Routes
  match '/:city/:id'       => 'search#show',  :city => City.routes_regexp, :as => :city_place


  ###########################################################################################
  # Detecting untranslated stringd
  ###########################################################################################
  if Rails.env.development?
    match 'translate'           => 'translate#index',     :as => :translate_list
    match 'translate/translate' => 'translate#translate', :as => :translate
    match 'translate/reload'    => 'translate#reload',    :as => :translate_reload
  end

   ###########################################################################################
  # Static page dynamic routing
  ###########################################################################################
  match '/terms'                    => 'home#staticpage' , :pages => :terms
  match '/fees'                     => 'home#staticpage' , :pages => :fees
  match '/privacy'                  => 'home#staticpage' , :pages => :privacy
  match '/contact'                  => 'home#staticpage' , :pages => :contact

  get '/robots.txt' => 'home#robot'

  # Error matching
  match '/404' => 'errors#page_not_found'
  match '/500' => 'errors#exception'

  match '/:pages' => 'home#staticpage'
end
