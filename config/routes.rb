Rails.application.routes.draw do

  #
  # Main App Page
  #
  root :to => "home#home"

  #
  # Open routes to the app
  #
  get  'sign_in', to: 'home#log_in'
  post 'sign_in_user', to: 'home#access_user'
  post 'sign_in_institution', to: 'home#access_institution'

  get 'raffles', to: 'raffles#index'
  get 'raffles/:id', to: 'raffles#show', as: :raffles_show
  get 'raffles/:id/buy', to: 'raffles#buy', as: :raffles_buy
  get 'raffles/:id/cancel', to: 'raffles#cancel', as: :raffles_cancel
  get 'raffles/:id/checkout', to: 'raffles#checkout', as: :raffles_checkout
  get 'raffles/:id/finish', to: 'raffles#finish', as: :raffles_finish
  post 'raffles/:id/check_tickets', to: 'raffles#check_tickets', as: :raffles_check_tickets

  #match "raffles/:id/checkout" => "raffles#checkout", as: :raffles_checkout, via: [:get, :post]


  #
  # User acess routes
  #
  get 'user', controller: 'user', action: 'profile', as: 'user_root'

  resource :user, only: [:destroy, :show, :update, :edit], controller: 'user' do
    get 'profile'
    get 'tickets'
  end


  #
  # Intitutions acess routes
  #
  get 'institution', controller: 'institution', action: 'profile', as: 'institution_root'

  resource :institution, only: [:destroy, :show, :update, :edit], controller: 'institution' do
    get 'profile'
  end

  namespace :institution do
    resources :raffles do

    end
  end


  #
  # Admin area rounting
  #
  namespace :admin do

    #
    # Admins Root
    #
    root :to => 'users#index' 

    resources :users, only: [:index, :destroy, :show, :new, :create, :update, :edit]

    resources :institutions, only: [:index, :destroy, :show, :new, :create, :update, :edit]

    resources :raffles, only: [:show, :edit, :destroy]
      
    get 'institutions_approval',  action: :institutions_approval, controller: 'institutions'
    get 'aprove_institution/:id', action: :aprove_institution,    controller: 'institutions', as: 'approve_institution'

    get 'raffles',                action: :index,                 controller: 'raffles'

    get 'financial',              action: :index,                 controller: 'financial'

    get 'withdraws',              action: :index,                 controller: 'withdraws'

    get 'reports',                action: :reports,               controller: 'reports'

  end

  #
  # Devise for Admin Authentication
  #
  devise_for :admins, path: 'admin', controllers: {sessions: "admin/sessions", passwords: "admin/passwords", registrations: "admin/registrations"}

  #
  # Devise for Users Authentication
  #
  devise_for :users, path: 'user', controllers: { sessions: "users/sessions", passwords: "users/passwords", registrations: "users/registrations"}

  #
  # Devise for Institutions Authentication
  #
  devise_for :institutions, path: 'institution', controllers: { sessions: "institutions/sessions", passwords: "institutions/passwords", registrations: "institutions/registrations"}
end
