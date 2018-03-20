Okapi::Application.routes.draw do

  mount StripeEvent::Engine => '/stripehook' # provide a custom path

  root 'homepage#index'

  resources :coupons, except: [ :index, :edit, :update  ] do
    member do
      get "apply_to_plan"
      get "apply_to_student"
    end
  end
  resources :password_resets
  resources :payments, only: [ :new, :create ]
  resources :plans
  resources :rosters, except: [ :index ] do
    member do
      get "enrollment_create"
      get "enrollment_remove"
    end
  end
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :single_charge, only: [ :new, :create ]
  resources :students, except: [ :index ] do
    member do
      get "sendinvite"
    end
    member do
      get "payments"
    end
    resources :payments
    resources :subscriptions
  end
  resources :users, except: [ :index, :destroy ] do
    member do
      get 'deactivate'
      get 'activate'
    end
  end
  resources :user_plans

  match '/admin', to: 'admin#index', via: 'get'
  match '/admin/students', to: 'admin#students', via: 'get'
  match '/admin/plans', to: 'admin#plans', via: 'get'
  match '/admin/coupons', to: 'admin#coupons', via: 'get'
  match '/admin/users', to: 'admin#users', via: 'get'
  match '/admin/subscriptions', to: 'admin#subscriptions', via: 'get'
  match '/admin/payments', to: 'admin#payments', via: 'get'
  match '/admin/balances', to: 'admin#balances', via: 'get'
  match '/signin',  to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/signup', to: 'users#new', via: 'get'
  match '/single_charge', to: 'single_charge#new', via: 'get'
  match '/faqs', to: 'pages#faqs', via: 'get'

end
