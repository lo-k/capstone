class UsersController < ApplicationController

  def home
    @user = User.find(session[:user_id])

    @greeting = Time.now.hour < 12 ? "morning" : "evening"

  end

  def upload_video
    upload = params[:video]
    upload_validation_status = EmotientApi.new.validate_video(upload)
    
    if upload_validation_status == "OK"
      # video = UploadIO.new(upload.tempfile, upload.content_type, upload.original_filename)
      # video_id = EmotientApi.new.upload_video(video)

      # kari_mixed_emotions
      video_id = "cf82beda-9600-8be9-cc04-414802410442"

      # q video
      # video_id = "d2f06aa9-b449-306f-f91c-e6bc02e104ec"

      video_status = EmotientApi.new.check_video_status(video_id)

      until video_status != "Analyzing"
        sleep 5
        video_status = EmotientApi.new.check_video_status(video_id)
      end

      if video_status == "Analysis Complete"
        @emo_results = EmotientApi.new.analyze_video(video_id)
        @playlist_category = EmoPlaylistCalc.new.select_playlist_category(@emo_results)
      else 
        flash[:error] = "There was an error with your video. Please try again."
      end

      redirect_to playlist_path
    else
      flash[:error] = upload_validation_status

      redirect_to home_path
    end
  end

  def playlist
    raise
    @playlist_uri = SpotifyApi.new.get_playlist(@playlist_category)
    @emotions_percents_hash = calc_emo_percents(@emo_results)
  end

#########################################
  private

  def calc_emo_percents(emo_results_hash)
    emo_percents_hash = {}
    total = 0

    emo_results_hash.each do |key, value|
      total += value
    end

    emo_results_hash.each do |key, value|
      if value > 0
        emo_percent = ((value/total)* 100).round(1)
      else
        emo_percent = 0
      end

      emo_percents_hash[:key] = emo_percent
    end

    emo_percents_hash.sort_by do |key, value|
      value
    end.reverse

    return emo_percents_hash
  end

end
