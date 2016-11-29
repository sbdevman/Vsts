param(
[string] $url
)
    # First we create the request.
$HTTP_Request = [System.Net.WebRequest]::Create($url)

# We then get a response from the site.
$HTTP_Response = $HTTP_Request.GetResponse()

# We then get the HTTP code as an integer.
$HTTP_Status = [int]$HTTP_Response.StatusCode

If ($HTTP_Status -eq 200) { 
    "Site is OK!" 
}
Else {
    throw "The Site may be down, please check!"
}

# Finally, we clean up the http request by closing it.
$HTTP_Response.Close()