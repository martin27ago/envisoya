Rails.application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#createFacebook'
  get 'auth/failure', to: 'home#login'
  get 'signout', to: 'sessions#signout'
  get '/', to: 'home#login'

  resources :sessions


  resource :home

  root :to => redirect('home')
  get '/home/login', to: 'home#login'
  get '/home/login/signin', to: 'sessions#signin'

  resources :users

  get '/users/:id/show', to: 'users#show'
  get '/users/new', to: 'users#new'
  get '/users/:id/users', to: 'users#users'
  root :to => redirect('/users')
end
