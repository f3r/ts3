HeyPalFrontEnd::Application.routes.draw do

  get "accomodation/show"

  get "accomodation/index"

  get "items/index"

  match '/auth/:provider/callback', to: 'sessions#auth'
  match '/auth/failure', to: 'sessions#fail'
  get "search/index"

  get "publish/index"


  match '/style_guides' => 'style_guides#index'
  match '/style_guides/:action' => 'style_guides'

  #match '/users/edit' => 'users#edit'
  #match '/users/update' => 'users#update'
  #match '/users/show' => 'users#show', :via => :get
  match '/users/item' => 'users#items'
  match '/notifications' => 'notifications#index'
  match '/connect' => 'users#connect'
  match '/cities'  => 'places#get_cities'

  resources :products

  resources :places do 

    member do
      get :wizard
      get :preview
      post :upload_photo      
    end

    resources :availabilities
  end
  
  match '/users/confirmation/:confirmation_token'  => 'users#confirm'
  match '/users/password/:reset_password_token'  => 'users#confirm_reset_password'


  match '/profile' => 'users#show', :as => :profile
  match '/edit_profile' => 'users#edit', :as => :edit_profile

  resources :users do

    collection do
      get  :confirm 
      post :resend_confirmation 
      post :reset_password
      get  :reset_password
      get  :confirm_reset_password
      post :confirm_reset_password
    end

    member do
      post :publish
    end

  end

  resources :sessions

  match '/signup'       =>  'users#new', :as => :signup
  match '/signup_complete'    => 'users#signup_complete', :as => :signup_complete
  match '/login'        =>  'sessions#new', :as => :login
  match '/logout'       =>  'sessions#destroy', :as => :logout

  match '/dashboard'    =>  'users#dashboard', :as => :dashboard

  match 'item/received' =>  'items#index'
  root :to => 'home#index'

end
