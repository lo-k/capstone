require 'rspotify'

class SpotifyApi
  RSpotify.authenticate(ENV['SPOTIFY_APP_ID'], ENV['SPOTIFY_APP_SECRET'])

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
  
    # currently pulling 20 records... figure out how to limit it?
    all_playlists = RSpotify::Category.find(category).playlists

    playlist_uri = all_playlists[index].uri

    return playlist_uri
  end

end