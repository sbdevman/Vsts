param(
[string] $dest
)

$err = ""
$list = $dest -split ','
"Please Wait ... "
foreach ($srv in $list) {
  "Checking Connection for " + $srv + "..."
  $out =  $srv -split ':'
  $ip =  $out[0]
  $port = $out[1]

 try 
{ 
  $tcp=new-object System.Net.Sockets.TcpClient 
  $tcp.connect($ip , $port)
  "Connection possible for $ip on port $port" 
  $tcp.close() 
} 
catch 
{ 
  $err += " Cannot connect server " + $ip + " on port " +  $port + "`n"
}

}

if(![string]::IsNullOrEmpty($error)){
throw $err
}