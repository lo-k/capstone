class UsersController < ApplicationController

  def home

  end

  def upload_video
    upload = params[:video]
    video = ActionDispatch::Http::UploadedFile.new(:tempfile => upload)

    video_id = EmotientApi.new.upload_video(video)
    
    raise
    
    redirect_to playlist_path
  end

  def playlist

  end

end
