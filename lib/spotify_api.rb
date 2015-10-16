class SpotifyApi

  CATEGORIES = {
    toplists: "Top Lists",
    mood: "Mood",
    party: "Party",
    pop: "Pop",
    popculture: "Trending",
    focus: "Focus",
    rock: "Rock",
    indie_alt: "Indie/Alternative",
    edm_dance: "EDM/Dance",
    chill: "Chill",
    dinner: "Dinner",
    sleep: "Sleep",
    hiphop: "Hip Hop",
    workout: "Workout",
    rnb: "RnB",
    country: "Country",
    folk_americana: "Folk & Americana",
    metal: "Metal",
    soul: "Soul",
    travel: "Travel"
  }

  LIMIT = 5

  def get_playlist(category)
    index = rand(0..LIMIT)
    response = HTTMultiParty.get("https://api.spotify.com/v1/browse/categories/" + 
      category + "/playlists?limit=#{LIMIT}",
      :headers => { 'Authorization' => "" } )
  end

end