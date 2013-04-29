$compname = $env:COMPUTERNAME.tolower()
$wmiOs = Get-WmiObject -Class Win32_OperatingSystem

[int]$freeMemory = 0 + $wmiOs.freephysicalmemory
[int]$totalMemory = 0 + $wmiOs.totalvisiblememorysize
[int]$memoryUsage = ($totalMemory - $freeMemory) / $totalMemory * 100

## Set the Graphite carbon server location and port number
$carbonServer = "graphite.cat.pdx.edu"
$carbonServerPort = 2003

#Get Unix epoch Time
$epochTime=[int](Get-Date -UFormat "%s") + 28800

## Formatted for Graphite
$graphiteString = ("wintel.terminal_server.${compname}_ds_cecs_pdx_edu.loadpercent.memory " + $memoryUsage + " " + $epochTime)

# Stream results to the Carbon server
$socket = New-Object System.Net.Sockets.TCPClient
$socket.connect($carbonServer, $carbonServerPort)
$stream = $socket.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)

#Write out metric to the stream.
$writer.WriteLine($graphiteString)

#Flush and write our metrics.
$writer.Flush()
$writer.Close()
$stream.Close()