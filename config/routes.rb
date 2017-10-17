Rails.application.routes.draw do

  root :to => redirect('home/login')

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy'
  get 'home/signin', to: 'sessions#signin'
  get '/', to: 'home#login'

  resources :sessions, only:[:create, :destroy]

  get '/home/login', to: 'home#login'

  resources :users

  get '/users/:id/show', to: 'users#show'
  get '/users/new', to: 'users#new'
  get '/users/:id/users', to: 'users#users'
  root :to => redirect('/users')
end
