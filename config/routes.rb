require 'resque/server'

Instafix::Application.routes.draw do
  mount Resque::Server.new, :at => "/resque"
  
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
    end
  end

  resource :static

  match "/about" => "static#about"

  root :to => "static#show"
end
