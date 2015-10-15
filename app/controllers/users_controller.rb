class UsersController < ApplicationController

  def home

  end

  def upload_video

    # create temp file (ruby method... /tmp)
    # creates it w random name (in ruby method)
    # delete it after done ideally (eventually os should del it)
    # in prod could write a sweeper progr to get rid fo them later

    # JS that validates size of video (Andrew says way more complicated)
    upload = params[:video]
    video = UploadIO.new(upload, 'video/quicktime', upload)
    # validate size of file here

    video_id = EmotientApi.new.upload_video(video)

    raise
    
    redirect_to playlist_path
  end

  def playlist

  end

end
