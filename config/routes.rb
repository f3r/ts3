HeyPalFrontEnd::Application.routes.draw do
  get 'sitemap.xml' => 'cached_sitemaps#sitemap'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  require_dependency 'preview_mails'
	match "/admin/mail_view" => PreviewMails, :anchor => false, :constraints => lambda { |request|
    request.env['warden'].authenticated?
    request.env['warden'].authenticate!
    %w(admin superadmin).include? request.env['warden'].user.role
  }

  # Redirect http://squarestays.com to http://www.squarestays.com
  constraints(:host => /^squarestays.com/) do
    root :to => redirect("http://www.squarestays.com")
    match '/*path', :to => redirect {|params, request| "http://www.squarestays.com/#{params[:path]}"}
  end

  # Redirect http://squarestaY.com to http://www.squarestayS.com
  constraints(:host => /^(www.)?squarestay.com/) do
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

  resources :listings do
    member do
      put   :publish
      put   :unpublish
      put   :update_currency
      put   :update_address
      get   :publish_check
    end
    resources :photos, :only => [:create, :update, :destroy] do
      put :sort, :on => :collection
    end
    resources :panoramas, :only => [:new, :create, :destroy]
  end

  resources :products do
    resources :questions do
      post :reply_to_message
    end
    resources :reviews, :only => [:create]
  end

  resources :image_cropper, :controller => :image_cropper, :only => [:new, :update, :create]

  ###########################################################################################
  # Saved searches
  ###########################################################################################
  resources :alerts do
    member do
      get :pause
      get :unpause
    end
  end

  match '/search/code/:search_code' => 'search#code',  :as => :show_search_code
  match '/search/alert/:alert_id'   => 'search#alert', :as => :show_search_alert

  ###########################################################################################
  # Inquiries
  ###########################################################################################
  resources :messages do
    member do
      put :mark_as_unread
      put :un_archive
    end
  end
  
  match '/archived_messages'  => 'messages#archived_messages', :as => :archived_messages
  match '/archived_messages/:id'  => 'messages#show_archived', :as => :archived_message

  resources :inquiries, :only => [:new, :create, :edit, :update] do
    collection do
      get :clear_form
    end
  end
  resources :transactions, :only => [:update]

  get 'paypal_callback', :to => 'payment_notifications#show'
  post 'paypal_callback', :to => 'payment_notifications#create', :as => :paypal_callback

  ###########################################################################################
  # Profiles
  ###########################################################################################
  resource :profile do
    member do
      post :update_avatar
      post :crop_avatar
    end
  end

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

  resources :feedbacks, :only => [:new, :create]

  resources :contacts, :only => [:create]
  match '/:city'           => 'search#index', :city => City.routes_regexp

  # SEO Routes
  match '/:city/:id'       => 'search#show',  :city => City.routes_regexp, :as => :city_product


  ###########################################################################################
  # Mobile
  ###########################################################################################

  match 'mobile'               => 'mobile#index',       :as => :mobile
  match 'mobile/cities'        => 'mobile#cities',      :as => :mobile_cities
  match 'mobile/search/:city'  => 'mobile#search',      :as => :mobile_search, :city => City.routes_regexp
  match 'mobile/info/:id'      => 'mobile#show_info',   :as => :mobile_show_info
  match 'mobile/map/:id'       => 'mobile#show_map',    :as => :mobile_show_map
  match 'mobile/photos/:id'    => 'mobile#show_photos', :as => :mobile_show_photos
  match 'mobile/inquire(/:id)' => 'mobile#inquire',     :as => :mobile_inquire

  ###########################################################################################
  # Detecting untranslated strings
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
  match '/alive'                    => 'home#alive'

  get '/robots.txt' => 'home#robot'

  # Error matching
  match '/404' => 'errors#page_not_found'
  match '/500' => 'errors#exception'

  match '/:pages' => 'home#staticpage'
end
