Boso::Application.routes.draw do

  resources :answers
  resources :questions

  get "home/index"
  
  get ':tag', to: 'home#index', as: :tag

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end