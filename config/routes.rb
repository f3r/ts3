HeyPalFrontEnd::Application.routes.draw do

  get   'search/index'
  match '/connect'        => 'users#connect'
  match '/cities'         => 'places#get_cities'
  match  '/cities/suggest' => 'home#suggest', :as => :city_suggest

  resources :places do
    member do
      get :wizard
      get :preview
      post :upload_photo
      get :photos
      put :update_currency
      put :publish
      put :unpublish
      get :rent
      match :availability
      post :confirm_rental
    end
    get :search, :on => :collection
    resources :availabilities
    resources :comments do
      post :reply_to_message
    end
  end
  
  get '/check_availability' => 'places#check_availability'

  ###########################################################################################
  # Messaging
  ###########################################################################################
  get  '/messages'      => 'messages#index',        :as => :messages
  get  '/messages/:id'  => 'messages#conversation', :as => :conversation
  post '/messages/:id'  => 'messages#create',       :as => :new_message
  delete '/messages/:id' => 'messages#delete_conversation', :as => :delete_conversation
  get '/messages/:id/mark_as_read' => 'messages#mark_as_read', :as => :mark_as_read
  get '/messages/:id/mark_as_unread' => 'messages#mark_as_unread', :as => :mark_as_unread

  ###########################################################################################
  # Profile
  ###########################################################################################
  match '/profile'      => 'users#show', :as => :profile
  match '/profile/edit' => 'users#edit', :as => :edit_profile

  resources :users do
    collection do
      get  :confirm
      post :resend_confirmation
      post :reset_password
      get  :reset_password
      get  :confirm_reset_password
      post :confirm_reset_password
      put  :change_preference
    end
    member do
      post :publish
    end
    match '/change_address' => "addresses#update"
    put '/change_password' => "users#change_password"
  end

  ###########################################################################################
  # Sessions, Registration & Providers
  ###########################################################################################
  resources :sessions
  match '/signup'          =>  'users#new',            :as => :signup
  match '/signup_complete' => 'users#signup_complete', :as => :signup_complete
  match '/login'           =>  'sessions#new',         :as => :login
  match '/logout'          =>  'sessions#destroy',     :as => :logout
  match '/users/confirmation/:confirmation_token'  => 'users#confirm'
  match '/users/password/:reset_password_token'    => 'users#confirm_reset_password'
  match '/auth/:provider/callback',  to: 'sessions#auth'
  match '/auth/failure',             to: 'sessions#fail'


  match '/my_places'    =>  'places#my_places', :as => :my_places

  root :to => 'home#index'
  
  # Error matching
  # http://techoctave.com/c7/posts/36-rails-3-0-rescue-from-routing-error-solution
  match '*a', :to => 'errors#routing'

  ###########################################################################################
  # Deprecated or Future routes
  ###########################################################################################
  # match 'item/received' =>  'items#index'
  # match '/notifications' => 'notifications#index'
  # match '/dashboard'    =>  'users#dashboard', :as => :dashboard
  # match '/users/item'    => 'users#items'
end
