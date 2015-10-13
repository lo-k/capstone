##Final Capstone Project Plan
[Trello Board](https://trello.com/b/qtN8AnOF/capstone)
[Initial Wireframe](https://trello-attachments.s3.amazonaws.com/56156844a57f2a35b9d3b2bc/3264x2448/45eef7e40786c7defad6025d77c8b24a/capstone_userflow_all.JPG)

---
####Problem Statment
Sometimes you want to listen to music according to your mood, but you don't want to manually find it.

---
####User Personas
  - People who want to have music suggested to them (people ages 15-30?)
  - People who are at a social gathering and want a playlist decided for them based on the context of the situation
  - People who want to play around with a gimmiky app at a party

---
####Market Research 
Existing Apps 
  - **Spotify** - You manually select the cateogory of playlist to listen to or build your own playlist.    
  - **Pandora** - You manually select a certain starting song/artist to kick off the playlist. Upvoting/downvoting customizes station.  
  - **Beats** - You manually fill out a sentence describing your mood, which then creates a playlist for you.  
  - **Songza.com** - You manually select your mood and it shows you many pre-made playlist options to play.  
  - **Moodfuse.com** - You manually select your mood from a drop down and also a genre, it returns a single youtube embedded video.  

APIs  
  - [musicovery.com](http://musicovery.com/api/V2/doc/documentation.php#playlist_tag)
    - Can search for a playlist by a 'mood' tag
    - Can also filter by release_year
  - [songza.com](http://tsenior.com/2014-05-09-songza-unofficial-api-documentation/) ** acquired by Google in 2014
    - Can search for a playlist by a mood 'name'
      - Returns a list of 'station_ids' that are tagged with that mood
      - Can query for that [station](http://songza.com/api/1/station/1399111)
        - Results include a url which will play that playlist on songza's website... not able to embedd the player
      - Cannot get songs by playlist through their API
      - Response in json  
  - [lastfm.com](http://www.last.fm/api/rest)
    - Can query songs by tags (tags include several mood terms)
    - Response in either json or XML
    - NOT ACCEPTING NEW API ACCOUNTS (issue opened at least +1 month ago)... whomp
  - [musicbrainz.com](https://musicbrainz.org/doc/Developer_Resources)

---
####Tools/Tech To Be Used
User-Facing App
  - Ionic framework (to make it a hybrid mobile app)
  - OAuth signin with Spotify
  - Angular?/React?
  - Possibly a small Sinatra server (v2)

Server-Side API App  
  - Ruby on Rails
  - Postgres
