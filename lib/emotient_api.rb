class EmotientApi
  EMO_URI = "https://api.emotient.com/v1/"
  INTERVAL = "summary"
  REPORT = "standard"
  GENDER = "combined"

  def upload_video(video)
    response = HTTMultiParty.post(EMO_URI + "upload",
      :query => { :file => video },
      :headers => { 'Authorization' => "a4687ea8-a1b0-4c24-88a7-3220f865a27a" , 
        'Content-Type' => 'multipart/form-data'})

    id = response.parsed_response["id"] 

    return id
  end

  def analyze_video(video_id)
    response = HTTMultiParty.get(EMO_URI + "analytics/" + video_id + 
      "/default/emotions?gender=combined&genderfilter=none&interval=summary&report=advanced",
      :headers => { 'Authorization' => "a4687ea8-a1b0-4c24-88a7-3220f865a27a" })

    emotions_hash = {
      disgust: response.parsed_response["data"]["disgust"],
      contempt: response.parsed_response["data"]["contempt"],
      surprise: response.parsed_response["data"]["surprise"],
      joy: response.parsed_response["data"]["joy"],
      anger: response.parsed_response["data"]["anger"],
      fear: response.parsed_response["data"]["fear"],
      sadness: response.parsed_response["data"]["sadness"] 
    }

    raise
    return emotions_hash
  end

end