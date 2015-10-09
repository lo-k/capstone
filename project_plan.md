###FINAL CAPSTONE PROJECT PLAN
[Trello Board](https://trello.com/b/qtN8AnOF/capstone)

####Problem Statment
    Sometimes you want to listen to music according to your mood, but you don't want to manually find it.

####Market Research 
  _Existing Apps_  
    - Spotify- You need to manually select the cateogory of playlist to listen to or build your own playlist manually  
    - Pandora- You need to manually select a certain starting song/artist to kick off the playlist. Upvoting/downvoting customizes station.  
    - Beats- You manually fill out a sentence describing your mood, which then creates a playlist for you.  
    - Songza.com - You manually select your mood and it shows you many pre-made playlist options to play.  
    - Moodfuse.com - You manually select your mood from a drop down and also a genre, it returns a single youtube embedded video.  

  _APIs_  
    - musicovery.com -- http://musicovery.com/api/V2/doc/documentation.php#playlist_tag
      - Can search for a playlist by a 'mood' tag
      - Can also filter by release_year

    - songza.com ** acquired by Google in 2014 -- http://tsenior.com/2014-05-09-songza-unofficial-api-documentation/
      - Can search for a playlist by a mood 'name'
        - Returns a list of 'station_ids' that are tagged with that mood
        - Can query for that station
          - http://songza.com/api/1/station/1399111
          - Results include a url which will play that playlist on songza's website... not able to embedd the player

    lastfm.com

####User Personas
  - People who want to have music suggested to them (people ages 15-30?)
  - People who are at a social gathering and want a playlist decided for them based on the context of the situation
  - People who want to play around with a gimmiky app at a party

####Tools/Technologies
  _User-Facing App_
    Ionic framework (to make it a hybrid mobile app)
    OAuth signin with Spotify
    Angular.js
    Possibly a small Sinatra server (v2)

  _Server-side API app_  
    Ruby on Rails
    Postgres
