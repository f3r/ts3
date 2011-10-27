HeyPalFrontEnd::Application.routes.draw do

  get "items/index"

  match '/auth/:provider/callback', to: 'sessions#auth'
  match '/auth/failure', to: 'sessions#fail'

  get "publish/index"


  match '/style_guides' => 'style_guides#index'
  match '/style_guides/:action' => 'style_guides'

  match '/users/edit' => 'users#edit'
  match '/users/update' => 'users#update'
  match '/users/show' => 'users#show'
  match '/users/item' => 'users#items'
  match '/notifications' => 'notifications#index'

  resources :products
  
  match '/users/confirmation/:confirmation_token'  => 'users#confirm'
  match '/users/password/:token'  => 'users#confirm_reset_password'

  resources :products

  resources :users do

    collection do
      get  :confirm # /users/confim
      post :resend_confirmation # /users/resend_confirmation
      post :reset_password
      get  :reset_password
      get  :confirm_reset_password
      post :confirm_reset_password
    end

    member do
      post :publish # /users/1/publish
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
