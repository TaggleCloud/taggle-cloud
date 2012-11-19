require 'sidekiq/web'

TaggleCloud::Application.routes.draw do

  resources :conferences do
    match "connections" => "conferences#connections"
    resources :attendances, :as => :attendees, :path => 'attendees', :on => :member
  end
  
  resources :coordinates
  
  resources :users do
    resources :abstracts
  end

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/linkedin", :as => :signin
  match "/signout" => "sessions#destroy", :as => :signout
  
  scope :constraints => lambda{ |req| !req.session[:user_id].blank? } do
    root :to => "users#dashboard", :as => :dashboard
  end

  match "/credits" => "landings#credits"
  root :to => "landings#home"
  
  mount Sidekiq::Web, at: "/sidekiq"
  
end
