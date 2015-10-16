Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_APP_ID'], ENV['SPOTIFY_APP_SECRET'], scope: 'playlist-modify-public'
end

OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)