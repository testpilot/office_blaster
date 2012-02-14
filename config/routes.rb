SongKick::Application.routes.draw do
  devise_for :users

  resource :playlist, :only => [:index]

  root :to => 'playlist#index'
end
