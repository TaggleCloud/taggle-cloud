TaggleCloud::Application.routes.draw do

  resources :connections, :attendances, :conferences, :tags,
            :abstracts, :emails

  match "/auth/:provider/callback" => "sessions#create"

  match "/signout" => "sessions#destroy", :as => :signout
  
  root :to => "landings#home"
end
