class EmoPlaylistCalc

  def select_playlist_category(emotions_hash)
      
    top_emotion_and_score = emotions_hash.max_by do |key , value|
      value
    end

    top_emotion = top_emotion_and_score[0].to_s

    case top_emotion
    
    when "disgust", "contempt", "angry"
      category_options = ["rock", "hiphop", "metal"]
    when "surprise", "joy"
      category_options = ["party", "pop", "edm_dance", "workout", "travel"]
    when "fear"
      category_options = ["chill", "sleep"]
    when "sadness"
      category_options = ["soul", "indie_alt", "travel"]
    end

    category = category_options.shuffle[0]
    
    return category
  end

end
