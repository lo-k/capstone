Rails.application.routes.draw do

  root 'welcome#index'

  # OmniAuth callback
  match '/auth/spotify/callback', to: 'sessions#create', via: [:get, :post]

  get '/selfie' => 'users#home'
  get '/playlist' => 'users#home_redirect' # auto redirect because you must POST to access a playlist

  post '/playlist' => 'users#upload_video'

  get '/signout' => 'sessions#destroy'
end
