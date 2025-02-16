 # this powershell script will return an access token and the channel ID, giving you the ability to use the Twitch API.
 
 $clientId     = 'CLIENT_ID'
 $clientSecret = 'CLIENT_SECRET'
 $username     = 'USERNAME' # the username of the channel youre pulling clips from
 
 $tokenUrl = 'https://id.twitch.tv/oauth2/token'
 $tokenBody = @{
     client_id     = $clientId
     client_secret = $clientSecret
     grant_type    = 'client_credentials'
 }

 $tokenResponse = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $tokenBody
 $accessToken = $tokenResponse.access_token
 Write-Output "generated access token: $accessToken"

 $userUrl = "https://api.twitch.tv/helix/users?login=$username"
 $userHeaders = @{
     'Authorization' = "Bearer $accessToken"
     'Client-Id'     = $clientId
 }

 $userResponse = Invoke-RestMethod -Uri $userUrl -Headers $userHeaders
 $broadcasterId = $userResponse.data[0].id
 Write-Output "ID: $broadcasterId"

 $clipsUrl = "https://api.twitch.tv/helix/clips?broadcaster_id=$broadcasterId&first=100"
 $clipsHeaders = @{
     'Authorization' = "Bearer $accessToken"
     'Client-Id'     = $clientId
 }

 $clipsResponse = Invoke-RestMethod -Uri $clipsUrl -Headers $clipsHeaders
 $clips = $clipsResponse.data

 if ($clips.Count -eq 0) {
     Write-Output "no clips were found for this channel."
 } else {
     $randomClip = $clips | Get-Random
     $clipUrl = $randomClip.embed_url + '&autoplay=true'
     Write-Output "random clip: $clipUrl"
 }


