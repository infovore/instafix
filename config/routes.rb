require 'sidekiq/web'
Instafix::Application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'sidekiq' && password == 'p1nk3rt0n'
  end 
  mount Sidekiq::Web => '/sidekiq'
  
  resource :session do
    collection do
      get 'callback'
      get 'logout'
    end
  end

  resources :photos do
    collection do
      post 'alter'
      get 'ingest'
      get 'ingest_all'
    end
  end

  resource :static

  match "/about" => "static#about"

  root :to => "static#show"
end
