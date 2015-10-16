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
    response = HTTMultiParty.get(EMO_URI + "analytics/" + video_id + "/aggregate?interval=" + 
      INTERVAL + "&report=" + REPORT + "&gender=" + GENDER,
      :headers => { 'Authorization' => "a4687ea8-a1b0-4c24-88a7-3220f865a27a" })

    emotions_hash = {
      sentiment: response.parsed_response[1][11],
      positive: response.parsed_response[1][12],
      negative: response.parsed_response[1][13],
      neutral: response.parsed_response[1][14],
      anger: response.parsed_response[1][15],
      contempt: response.parsed_response[1][16],
      disgust: response.parsed_response[1][17],
      fear: response.parsed_response[1][18],
      joy: response.parsed_response[1][19],
      sadness: response.parsed_response[1][20],
      surprise: response.parsed_response[1][21]
    }

    return emotions_hash
  end

end