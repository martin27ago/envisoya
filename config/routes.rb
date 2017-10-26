Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  root :to => redirect('home/login')

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy'
  get 'home/signin', to: 'sessions#signin'
  get '/', to: 'home#login'

  resources :sessions, only:[:create, :destroy]

  get '/home/login', to: 'home#login'

  resources :users

  root :to => redirect('/users')

  resources :deliveries

  get 'deliveries/active/:id', to: 'deliveries#active'



  root :to => redirect('/deliveries')

  resources :shippings do
    get 'calculate_cost'
  end

  resources :shippings

  root :to => redirect('/shippings')

  get 'application/loadDataBase', to: 'application#loadDataBase'

  get 'application/deliveriesJson', to: 'application#deliveriesJson'

end
