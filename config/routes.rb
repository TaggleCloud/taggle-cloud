TaggleCloud::Application.routes.draw do

  resources :conferences do
    resources :connections, :only => :index, :on => :member
    resources :attendances, :on => :member
  end

  match "/auth/:provider/callback" => "sessions#create"

  scope :constraints => lambda{|req| !req.session[:user_id].blank? } do
    match '/profile' => "users#profile", :as => :profile
    match "/signout" => "sessions#destroy", :as => :signout
  end

  root :to => "landings#home"
end
