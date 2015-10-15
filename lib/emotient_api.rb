class EmotientApi
  EMO_URI = "https://api.emotient.com/v1/upload"

  def upload_video(video_path)
    response = HTTMultiParty.post(EMO_URI,
      :query => { :file => File.new(video_path) },
      :headers => { 'Authorization' => "a4687ea8-a1b0-4c24-88a7-3220f865a27a" , 'Content-Type' => 'multipart/form-data'})

      # :headers => { 'Authorization' => "#{ENV['EMOTIENT_KEY']}", 'Content-Type' => 'multipart/form-data'})

    # response = HTTMultiParty.get('http://api.emotient.com/v1/media',
    #   :headers => { 'Authorization' => "a4687ea8-a1b0-4c24-88a7-3220f865a27a" })

    raise 

    return response
  end

end