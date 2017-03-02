Rails.application.routes.draw do
  root to: 'home#index'

  post '/set-playlist', to: 'playlists#set_playlist', as: 'set_playlist'
  get '/playlist', to: 'playlists#show_playlist', as: 'playlist'
  get '/get-playlist-info', to: 'playlists#get_playlist', defaults: {format: 'js'}
  get '/get-youtube-meta', to: 'meta#get_youtube_meta', defaults: {format: 'js'}
end
