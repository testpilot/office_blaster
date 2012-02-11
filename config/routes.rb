SongKick::Application.routes.draw do
  resource :playlist, :only => [:index]

  root :to => 'playlist#index'
end
