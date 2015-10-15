class EmotientApi
  EMO_URI = "https://api.emotient.com/v1/upload"

  def upload_video(video)
    response = HTTMultiParty.post(EMO_URI,
      :query => { :file => video },
      :headers => { 'Authorization' => "a4687ea8-a1b0-4c24-88a7-3220f865a27a" , 'Content-Type' => 'multipart/form-data'})

    id = response.parsed_response["id"] 

    return id
  end

end