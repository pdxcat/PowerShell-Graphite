PowerShell-Graphite
===================

CAT PowerShell scripts written to pipe data into a Graphite instance.

Get-SoftwareStats.ps1

This script is used to gather information about what software is being used by users on a windows terminal server.
The script count the total number of users using a piece of software at then sends the counts to graphite. Where it 
is graphed. 

Known Bugs
March 4, 2013 - When creating a list of software count to send to graphite a blank line is sent also. 
