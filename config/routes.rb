TaggleCloud::Application.routes.draw do

  resources :conferences do
    match "connections" => "conferences#connections"
    resources :attendances, :as => :attendees, :path => 'attendees', :on => :member
  end
  
  resources :users do
    match "/users/:id" => "users#profile"
    resources :attendances
  end

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/linkedin", :as => :signin
  match "/signout" => "sessions#destroy", :as => :signout

  scope :constraints => lambda{ |req| !req.session[:user_id].blank? } do
    root :to => "users#dashboard", :as => :dashboard
  end

  match "/credits" => "landings#credits"
  root :to => "landings#home"
  
  match "/users/:id" => "users#profile"
end
