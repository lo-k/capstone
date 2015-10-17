class EmotientApi
  EMO_URI = "https://api.emotient.com/v1/"

  def upload_video(video)
    response = HTTMultiParty.post(EMO_URI + "upload",
      :query => { :file => video },
      :headers => { 'Authorization' => ENV['EMOTIENT_KEY'] , 
        'Content-Type' => 'multipart/form-data'})

    id = response.parsed_response["id"] 

    return id
  end

  def analyze_video(video_id)
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