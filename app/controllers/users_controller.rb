class UsersController < ApplicationController

  def home
    @user = User.find(session[:user_id])

    @greeting = Time.now.hour < 12 ? "morning" : "evening"

  end

  def upload_video
    # Need to temp store the video so it has a file path
    # Need to adapt this to handle other video file types
    # upload = params[:video]
    # video = UploadIO.new(upload, 'video/quicktime', upload)
    
    # video_id = EmotientApi.new.upload_video(video)

    # alice_sad
    # video_id = "cf1efe65-05f4-a19d-b488-ddbe0211042a"

    # kari_mixed_emotions
    # video_id = "cf82beda-9600-8be9-cc04-414802410442"

    # q video
    video_id = "d2f06aa9-b449-306f-f91c-e6bc02e104ec"
    video_status = "Analyzing"

    until video_status != "Analyzing"
      # t = Time.now
      video_status = EmotientApi.new.check_video_status(video_id)
      
      sleep 5
      # sleep(t + 10 - Time.now)
    end

    if video_status == "Analysis Complete"
      emo_results = EmotientApi.new.analyze_video(video_id)
      playlist_category = EmoPlaylistCalc.new.select_playlist_category(emo_results)
    else 
      flash[:error] = "There was an error with your video. Please try again."
    end

    redirect_to playlist_path(playlist_category)
  end

  def playlist
    @playlist_uri = SpotifyApi.new.get_playlist(params[:playlist_category])

    @disgust_percent = ((0.27/16.34)* 100).round(1)
    @contempt_percent = ((0/16.34) * 100).round(1)
    @surprise_percent = ((2.86/16.34) * 100).round(1)
    @joy_percent = ((13.21/16.34) * 100).round(1)
    @anger_percent = ((0/16.34) * 100).round(1)
    @fear_percent = ((0/16.34) * 100).round(1)
    @sadness_percent = ((0/16.34) * 100).round(1)

  end

end
