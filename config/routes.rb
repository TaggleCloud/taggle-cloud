TaggleCloud::Application.routes.draw do

  resources :conferences do
    match "connections" => "conferences#connections"
    resources :attendances, :as => :attendees, :path => 'attendees', :on => :member
  end

  resources :users, :only => :show

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  scope :constraints => lambda{ |req| !req.session[:user_id].blank? } do
    root :to => "users#dashboard", :as => :dashboard
  end

  root :to => "landings#home"
end
