# SpotifyToday
A Today Widget for Spotify. Control playback and save the current song without opening the app. 

## Building

This requires your Spotify profile to save songs. You need to get a client key and secret from developer.spotify.com and store them in a plist file called `oauth.plist`. Just make the file and add a key value for "OAUTH_SECRET_KEY" and "OAUTH_CONSUMER_KEY"

## Why? 

I like to keep Spotify minimized, but if I'm listening to a playlist and a new song comes on, I want to see the song name and maybe save it. This will let you do it from Notification Center.