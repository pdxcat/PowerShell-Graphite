PowerShell-Graphite
===================

CAT PowerShell scripts written to gather statistical data from a Windows machine and pipe that data into a Graphite instance.

Current Scripts
---------------

<dl>
  <dt>Get-SoftwareStats.ps1</dt>
  <dd>Gather information about what software (processes) are being run. The script counts the total number of running instances of a particular process and then sends the counts to Graphite.</dd>
  <dt>Get-RDPStats.ps1</dt>
  <dd>Counts the number of users currently logged into the machine by using psloggedon (http://technet.microsoft.com/en-us/sysinternals/bb897545.aspx) then sends that count to Graphite.</dd>
  <dt>Get-CPUStats.ps1</dt>
  <dd>Gets the current load percentage snapshot for each CPU from WMI and then sends those percentages to Graphite.</dd>
  <dt>Get-MemStats.ps1</dt>
  <dd>Gets the current free available physical memory and the maximum available physical memory from WMI, creates an in-use percentage value and then sends that percentage to Graphite.</dd>
</dl>

Known Bugs
----------
GetSoftwareStats.ps1
* March 4, 2013 - When creating the list of running processes to send to Graphite a process named the empty string is sent also.
