Boso::Application.routes.draw do

  resources :answers
  resources :questions
  resources :tags

  get "home/index"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end