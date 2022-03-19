## FIND OLD PROFILES INSIDE SERVERS

## Select search method removing comment from SERVERS variable
## Alter <WORKER_GROUP_NAME> by your workerGroup
#$servers = (Get-XAWorkerGroup -WorkerGroupName "<WORKER_GROUP_NAME>").servernames | Sort-Object #by WORKER GROUP
## Alter <APPLICATION_NAME> by your app name
#$servers = (Get-XAApplicationReport -BrowserName "<APPLICATION_NAME>").servernames | Sort-Object #by App with Servers List

Write-Host @"
Check hung profile by:
[1] Worker Group
[2] Application
[3] Server
"@
$option = Read-Host ": "
$object = Read-Host "Target: "

$servers = switch($option) {
    1 { (Get-XAWorkerGroup -WorkerGroupName $object).servernames | Sort-Object }
    2 { (Get-XAApplicationReport -BrowserName $object).servernames | Sort-Object }
    3 { (Get-XAApplicationReport -BrowserName $object).servernames | Sort-Object }
    default { Break }
}

$username = Read-Host "Input username: "

#if user be found on server - it will return Server Name
$servers | ForEach-Object { if(Test-Path \\$_\d$\users\$username*){ 
        $session = $null
        $user_profile = Get-Item \\$_\d$\users\$username*
        Write-Host "`nServer $_ found old profile entry!" 
        $user_profile.FullName
        $user_profile.LastWriteTime.DateTime

        $session = Get-XASession -ServerName $_ | Where-Object {$_.AccountName -match $username}
        if(!$session){
            Remove-Item \\$_\d$\users\$username* -Recurse -Force -Confirm
        }
    }  
}