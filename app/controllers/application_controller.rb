# Do I need to require gems here?

# Requiring in my Emotient API file
# require 'emotient_api'
# require 'emo_playlist_calc'
# require 'spotify_api'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
