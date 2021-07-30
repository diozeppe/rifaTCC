Rails.application.routes.draw do

  #
  # Main App Page
  #
  root :to => "home#home"

  #
  # Open routes to the app
  #
  get  'sign_in',             to: 'home#log_in'
  get  'terms_of_service',    to: 'home#terms_of_service'
  post 'sign_in_user',        to: 'home#access_user'
  post 'sign_in_institution', to: 'home#access_institution'

  #
  # Processo principal de compra e acesso a campanhas
  #
  get  'raffles',                   to: 'raffles#index'
  get  'raffles/:id',               to: 'raffles#show',          as: :raffles_show
  get  'raffles/:id/buy',           to: 'raffles#buy',           as: :raffles_buy
  get  'raffles/:id/cancel',        to: 'raffles#cancel',        as: :raffles_cancel
  get  'raffles/:id/checkout',      to: 'raffles#checkout',      as: :raffles_checkout
  get  'raffles/:id/finish',        to: 'raffles#finish',        as: :raffles_finish
  post 'raffles/:id/check_tickets', to: 'raffles#check_tickets', as: :raffles_check_tickets

  #match "raffles/:id/checkout" => "raffles#checkout", as: :raffles_checkout, via: [:get, :post]

  match "user/sign_in"        => "home#log_in", via: [:get, :post]
  match "institution/sign_in" => "home#log_in", via: [:get, :post]

  #
  # User acess routes
  #
  get 'user', controller: 'user', action: 'profile', as: 'user_root'

  resource :user, only: [:destroy, :show, :update, :edit], controller: 'user' do
    get 'profile'
    get 'tickets'
    get ':id/confirm_received', to: 'user#confirm_received', as: 'confirm_received'
  end

  #
  # Intitutions acess routes
  #
  get 'institution', controller: 'institution', action: 'profile', as: 'institution_root'

  resource :institution, only: [:destroy, :show, :update, :edit], controller: 'institution' do
    get 'profile'
    get ':id/confirm_sended', to: 'institution#confirm_sended', as: 'confirm_sended'
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

    #
    # Navbar routes
    #
    get 'raffles',   action: :index,   controller: 'raffles'
    get 'financial', action: :index,   controller: 'financial'
    get 'withdraws', action: :index,   controller: 'withdraws'
    get 'reports',   action: :general, controller: 'reports'

    #
    # Reports JSON
    #
    get 'get_sales',                     action: :get_sales,                     controller: 'reports'
    get 'get_user_registrations',        action: :get_user_registrations,        controller: 'reports'
    get 'get_institution_registrations', action: :get_institution_registrations, controller: 'reports'
    get 'get_revenue',                   action: :get_revenue,                   controller: 'reports'
    get 'get_new_raffles',               action: :get_new_raffles,               controller: 'reports'
  end

  #
  # Devise for Admin Authentication
  #
  devise_for :admins, path: 'admin', controllers: {sessions: "admin/sessions"}

  #
  # Devise for Users Authentication
  #
  devise_for :users, path: 'user', controllers: { sessions: "users/sessions", passwords: "users/passwords", registrations: "users/registrations", confirmations: 'users/confirmations'}

  #
  # Devise for Institutions Authentication
  #
  devise_for :institutions, path: 'institution', controllers: { sessions: "institutions/sessions", passwords: "institutions/passwords", registrations: "institutions/registrations", confirmations: 'institutions/confirmations'}
end
