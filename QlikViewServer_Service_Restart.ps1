<#
		------------------------------------------------
		Script: Qlikview Server Service Restart
		Author: Aadil Madarveet
        Date: 4th April 2019
		------------------------------------------------
#>

#Provide the list of server names as comma separated values
$ServerList = @("SERVERNAME1","SERVERNAME2","SERVERNAME3","SERVERNAME4","SERVERNAME5")
#Provide the name of the service that you would want to restart
$ServiceName = 'QlikViewServer'
$LogFileName =  "ServiceRestartDetails_"+"$(get-date -Format ddMMyyyy)"+".log"
$LogFile = "C:\LogFolder\" + $LogFileName

For ($i=0; $i -lt $ServerList.Length; $i++) {

    $ServiceDetails = Get-Service -InputObject (Get-Service -Computer $ServerList[$i] -Name $ServiceName)

    IF( $ServiceDetails.STATUS -EQ "RUNNING" ) {
        Restart-Service -InputObject (Get-Service -Computer $ServerList[$i] -Name $ServiceName)
    } ELSE {
        $Log =  "$(get-date -Format ddMMyyyy_H:mm:ss)" + " - WARNING - " + $ServerList[$i] + " - "+ $ServiceName + " is not running."
        Write-Output $Log | Out-File -Filepath $LogFile -append
    }
	
	Start-Sleep -s 15
    $ServiceDetailsAfter = Get-Service -InputObject (Get-Service -Computer $ServerList[$i] -Name $ServiceName)

    IF( $ServiceDetailsAfter.STATUS -EQ "RUNNING" ) {
        $Log = "$(get-date -Format ddMMyyyy_H:mm:ss)" + " - INFO - " + $ServerList[$i] + " - "+ $ServiceName + " restart successful. Service status is " + $ServiceDetailsAfter.STATUS
        Write-Output $Log | Out-File -Filepath $LogFile -append
    } ELSE {
        $Log = "$(get-date -Format ddMMyyyy_H:mm:ss)" + " - WARNING - " + $ServerList[$i] + " - "+ $ServiceName + " restart failed. Service status is " + $ServiceDetailsAfter.STATUS
        Write-Output $Log | Out-File -Filepath $LogFile -append
    }
}