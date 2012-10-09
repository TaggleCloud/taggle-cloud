TaggleCloud::Application.routes.draw do

  resources :conferences do
    resources :connections, :only => :index, :on => :member
    resources :attendances, :on => :member, :as => :attendees, :path => 'attendees'
  end

  resources :users, :only => :show

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  scope :constraints => lambda{ |req| !req.session[:user_id].blank? } do
    root :to => "users#profile", :as => :profile
  end

  root :to => "landings#home"
end
