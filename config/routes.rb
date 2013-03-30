Boso::Application.routes.draw do

  resources :answers
  resources :questions

  get "home/index"
  # get 'tags', to: 'tags#index'
  
  # get ':tag', to: 'home#index', as: :tag
  # match 'tags/:tag' => 'tags#show', as: ':tag'



  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  

  resources :tags, path: "", except: [:index, :new, :create], constraints: { :id => /.*/ }
  # resources :tags, constraints: { :id => /.*/ }

  # match '/:id' => 'tags#show'
  # match "/tags/:id" => redirect("/%{id}")
  
end