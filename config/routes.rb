Boso::Application.routes.draw do

  resources :answers
  resources :questions

  get "home/index"
  devise_for :users
  resources :users

  authenticated :user do
    root :to => 'home#index'
  end
    
  root :to => "home#index"
  
  resources :tags, path: "", except: [:index, :new, :create], constraints: { :id => /.*/ }  
  # resources :tags, path: "", except: [:index, :new, :create], constraints: lambda{ |req| req.params[:id] != '/livereload' && req.params[:id] =~ /.*/ }  
  # resources :tags, path: "", except: [:index, :new, :create], constraints: lambda{ |req| req.env['REQUEST_PATH'] != '/livereload' && req.params[:id] =~ /.*/ }

  
end