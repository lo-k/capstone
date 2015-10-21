class EmotientApi
  EMO_URI = "https://api.emotient.com/v1/"

  MIN_VID_SIZE = 8200000    # 7.8 MB -- Est size of ~10 sec video?
  MAX_VID_SIZE = 31457280   # 30 MB -- Est size of ~25 sec video
  
  ACCEPTED_VID_FORMATS = 
    [
      "video/avi",          #.avi
      "video/msvideo",      #.avi
      "video/x-msvideo",    #.avi
      "video/quicktime",    #.mov
      "video/mp4",          #.mp4
      "audio/mpeg",         #.mpg
      "audio/x-ms-wmv",     #.wmv
    ]

  def self.validate_video(video)
    status = "OK"

    if ACCEPTED_VID_FORMATS.exclude?(video.content_type)
      status = "video is not in the correct format"
    elsif video.size < MIN_VID_SIZE
      status = "video is too small"
    elsif video.size > MAX_VID_SIZE
      status = "video is too big"
    end

    return status
  end

  def self.upload_video(video)
    response = HTTMultiParty.post(EMO_URI + "upload",
      :query => { :file => video },
      :headers => { 'Authorization' => ENV['EMOTIENT_KEY'] , 
        'Content-Type' => 'multipart/form-data'})

    id = response.parsed_response["id"] 

    return id
  end

  def self.check_video_status(video_id)
    response = HTTMultiParty.get(EMO_URI + "/media/" + video_id,
      :headers => { 'Authorization' => ENV['EMOTIENT_KEY'] })

    status = response.parsed_response["status"]
    # status = "Analyzing"

    return status
  end

  def self.analyze_video(video_id)
    response = HTTMultiParty.get(EMO_URI + "analytics/" + video_id + 
      "/default/emotions?gender=combined&genderfilter=none&interval=summary&report=advanced",
      :headers => { 'Authorization' => ENV['EMOTIENT_KEY'] })

    emotions_hash = {
      disgust: response.parsed_response["data"]["disgust"],
      contempt: response.parsed_response["data"]["contempt"],
      surprise: response.parsed_response["data"]["surprise"],
      joy: response.parsed_response["data"]["joy"],
      anger: response.parsed_response["data"]["anger"],
      fear: response.parsed_response["data"]["fear"],
      sadness: response.parsed_response["data"]["sadness"] 
    }

    return emotions_hash
  end

end