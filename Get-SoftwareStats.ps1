$include = "include.txt"
$server = "raven.cat.pdx.edu"
$exclude = "exclude.txt"

##### Function to send stuff to graphite #####
function sendToGraphite{
    param(
        $send
    )
    ## Set the Graphite carbon server location and port number
    $carbonServer = $server
    $carbonServerPort = 2003

    #Stream results to the Carbon server
    $socket = New-Object System.Net.Sockets.TCPClient 
    $socket.connect($carbonServer, $carbonServerPort) 
    $stream = $socket.GetStream() 
    $writer = new-object System.IO.StreamWriter($stream)

    #Write out metric to the stream.
    $writer.WriteLine($send)

    #Flush and write our metrics.
    $writer.Flush() 
    $writer.Close() 
    $stream.Close() 
}

$excludelist = get-content $exclude
$list = get-process | select -ExpandProperty processname | Sort-Object -Unique

## Makes every thing lower case. 
for ($i=0; $i -lt $list.length; $i++) { $list[$i] = $list[$i].tolower() }


## Exlcudes any items in the exclude list. 
foreach($eitem in $excludelist){
    $list = $list | where{$_.tolower() -notmatch $eitem.ToLower()}
}

## compares current processes to know processes and get the new processes. 
$diff = Compare-Object $list (Get-Content $include) | Where {$_.SideIndicator -eq "=>" } | Select -expand InputObject

foreach($item in $list){
    
    $processList = get-process $item | select -ExpandProperty processname 
    $count = 0;
    foreach($itemcount in $processList){
        $count += 1;
    }
        
    #Get Unix epoch Time
    $epochTime=[int](Get-Date -UFormat "%s") + 28800

    $format = ("wintel.terminal_server.borr_ds_cecs_pdx_edu.software.$item " + $count + " " + $epochTime)
    #sendToGraphite $format
}

foreach($item in $diff){
    $format = ("wintel.terminal_server.borr_ds_cecs_pdx_edu.software.$item " + 0 + " " + $epochTime)
    #sendToGraphite $format
}

$diff2 = Compare-Object $list (Get-Content $include) | Where {$_.SideIndicator -eq "<=" } | Select -expand InputObject

foreach($item in $diff2){
     $item | out-file $include -Encoding ascii -Append -NoClobber
   
}


$file = Get-Content $include
$file = $file | Sort-Object
$file | out-file $include -Encoding ascii
