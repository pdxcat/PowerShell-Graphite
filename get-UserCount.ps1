## get-UserCount.ps1
## Sandeep S Parmar
## 2/8/2013
## This is used to grab the total count and the active on the server and send the counts to graphite. 

$compname = $env:COMPUTERNAME

## Used to get the infomration who is loggedon and which users are active. 
$path=\\cecs\resources\programs\programs\tools\psloggedon.exe \\$compname 2>&1 | where{$_ -match "cecs"} | where{$_ -notmatch $env:USERNAME}
$active = query user /server:$compname | ?{$_ -match "\b$UserName\b"} | ?{$_ -match "rdp-tcp#\d*"}

## Used the get the total count. 
$totalcount = $path.count

## Used to get the count for 
$activecount=0;
foreach ($item in $active){
    $activecount+= 1
}

## Set the Graphite carbon server location and port number
$carbonServer = "graphite.cat.pdx.edu"
$carbonServerPort = 2003

#Get Unix epoch Time
$epochTime=[int](Get-Date -UFormat "%s") + 28800

## Formatted for graphite
$totalusers = ("wintel.ts_cecs_pdx_edu.totalusers " + $totalcount + " " + $epochTime)
$activeusers = ("wintel.ts_cecs_pdx_edu.activeusers " + $activecount + " " + $epochTime)

#Stream results to the Carbon server
$socket = New-Object System.Net.Sockets.TCPClient 
$socket.connect($carbonServer, $carbonServerPort) 
$stream = $socket.GetStream() 
$writer = new-object System.IO.StreamWriter($stream)

#Write out metric to the stream.
$writer.WriteLine($totalusers)
$writer.WriteLine($activeusers)

#Flush and write our metrics.
$writer.Flush() 
$writer.Close() 
$stream.Close() 