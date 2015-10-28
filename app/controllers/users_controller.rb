class UsersController < ApplicationController

  def home
    @user = User.find(session[:user_id])
    @greeting = Time.now.hour < 12 ? "morning" : "evening"
  end

  def home_redirect
    redirect_to selfie_path
  end

  def upload_video

    upload = params[:video]
    upload_validation_status = EmotientApi.validate_video(upload)

    if upload_validation_status == "OK"
      video = UploadIO.new(upload.tempfile, upload.content_type, upload.original_filename)
      video_id = EmotientApi.upload_video(video)

      # kari_mixed_emotions
      # video_id = "cf82beda-9600-8be9-cc04-414802410442"

      # q video
      # video_id = "d2f06aa9-b449-306f-f91c-e6bc02e104ec"

      video_status = EmotientApi.check_video_status(video_id)

      until video_status != "Analyzing"
        sleep 5
        video_status = EmotientApi.check_video_status(video_id)
      end

      if video_status == "Analysis Complete"
        emo_results = EmotientApi.analyze_video(video_id)
        playlist_category = EmoPlaylistCalc.select_playlist_category(emo_results)
      else 
        flash[:error] = "There was an error with your video. Please try again."
      end
      
      @playlist_uri = SpotifyApi.new.get_playlist(playlist_category)
      @emotions_percents_hash = ApiHelper.create_emo_percents_hash(emo_results)

    else
      flash[:error] = upload_validation_status | "Please try again."
    end

    render 'playlist'
  end

end
