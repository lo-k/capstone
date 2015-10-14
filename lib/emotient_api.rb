class EmotientApi
  EMO_URI = "https://api.emotient.com/v1/upload"

  def video_upload(video)
    response = HTTParty.post(EMO_URI,
      :headers => { 'Authorization: #{ENV["EMOTIENT_KEY"]}', 'Content-Type' => 'multipart/form-data'})

    return response
  end

end