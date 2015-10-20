class SessionsController < ApplicationController

  def create
    @user = User.find_or_create_from_omniauth(auth_hash)
    session[:user_id] = @user.id

    redirect_to selfie_path
  end

  def oauth_failure
    flash[:error] = "There was an error with signing in with Spotify. Please try again."
    
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end
