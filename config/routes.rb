Rails.application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]

  root to: "home#show"

  resources :users

  root :to => redirect('/users')
  get '/users/:id/show', to: 'users#show'
  get '/users/:id/users', to: 'users#users'
end
