function Write-Settings () {
    Write-host ""
    Write-host "Settings menu:"
    Write-host "Select the setting to change:"
    Write-host "A) File path for monitored files"
    Write-host "B) Logging"
    Write-host ""

    $reply = Read-Host -Prompt "Please enter 'A', 'B', or 'C'"
    return $reply
}

function Write-Logging () {
    Write-Host ""
    Write-Host "Logging will write to the file log.txt in the main folder of the application."
    Write-Host "Would you like to turn logging on? "
    Write-Host ""

    $reply = Read-Host -Prompt "Enter 'Y' or 'N': "

    if ($reply -eq "Y".ToUpper()) {
        return $true
    }

    else {
        return $false
    }
}