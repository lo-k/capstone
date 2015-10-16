class UsersController < ApplicationController

  def home
    @user = User.find(session[:user_id])

  end

  def upload_video
    # Need to adapt this to handle other video file types
    # upload = params[:video]
    # video = UploadIO.new(upload, 'video/quicktime', upload)
    
    # video_id = EmotientApi.new.upload_video(video)

    # alice_sad
    # video_id = "cf1efe65-05f4-a19d-b488-ddbe0211042a"

    # kari_mixed_emotions
    video_id = "cf82beda-9600-8be9-cc04-414802410442"

    emo_results = EmotientApi.new.analyze_video(video_id)
    playlist_category = EmoPlaylistCalc.new.select_playlist_category(emo_results)
    spotify_playlist_id = SpotifyApi.new.get_playlist(playlist_category)
    raise 

    redirect_to playlist_path
  end

  def playlist

  end

end
