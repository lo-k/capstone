class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

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
      upload.original_filename = (upload.original_filename == "blob") ? "blob.webm" : upload.original_filename
      video = UploadIO.new(upload.tempfile, upload.content_type, upload.original_filename)
      video_id = EmotientApi.upload_video(video)

      # TEST VIDEOS:
        # kari_mixed_emotions
        # video_id = "cf82beda-9600-8be9-cc04-414802410442"

        # q video
        # video_id = "d2f06aa9-b449-306f-f91c-e6bc02e104ec"

        # video that errored during analyzation
        # video_id = "d253f7d3-ff59-9eae-431e-8da802e1041a"

      video_status = EmotientApi.check_video_status(video_id)

      until video_status != "Analyzing"
        puts "UPDATE: video_status = " + video_status
        sleep 5
        video_status = EmotientApi.check_video_status(video_id)
      end

      if video_status == "Analysis Complete"
        puts "UPDATE: Video processing complete. Starting analysis of results."
        
        emo_results = EmotientApi.analyze_video(video_id)
        puts "UPDATE: Emotion results = "
        puts emo_results
        
        playlist_category = EmoPlaylistCalc.select_playlist_category(emo_results)
        puts "UPDATE: Playlist category = " + playlist_category
        
        @playlist_uri = SpotifyApi.new.get_playlist(playlist_category)
        @emotions_percents_hash = ApiHelper.create_emo_percents_hash(emo_results)
        puts 'UPDATE: Emotions = ' 
        puts @emotions_percents_hash
      else 
        flash[:error] = "There was an error with processing your video. Please try a new video."
        puts "UPDATE: There was an error on Emotient's side with processing the video."
      end

    else
      flash[:error] = upload_validation_status
    end

    render 'playlist'
  end

end
