<#

This is the main file to be run when using this program.
For readability reasons, the code has been seperated with
large amounts of whitespace.

#>

# Base configuration
$file = "./files" # the base file
$Running = $true #used for persistence of the application
$logging = $false
$progResponse = " "

# Import the files needed for functions
. .\functions\base.ps1
. .\functions\settings.ps1
. .\functions\watch.ps1


while($Running) {
    # Calls the function to request the choices
    $response = Request-Choices

    # Checks if the response is "A"
    # If so will start to create the baseline for the monitoring
    if ($response -eq "A".ToUpper()) {
        $count = 0
        #Delete baseline.txt if it already exists
        Clear-Baseline-If-Already-Exists
        
        # Calculate hash from the target files and store in baseline
        Write-Host "Calculating Hashes..." -ForegroundColor Cyan

        #Collect all the files in the target folder
        $files = Get-ChildItem -Path $file

        # For each file, calculate the hash and write it to baseline.txt
        foreach ($f in $files) {
            $hash = Measure-File-Hash $f.FullName
            "$($hash.Path) | $($hash.hash)" | Out-File -FilePath .\baseline.txt -Append
            $count +=1
        }
        Write-Host "Hashes calculated, $($count) total files hashed." -ForegroundColor Green
    } 



    elseif ($response -eq "B".ToUpper()) {
        #Calls the function Watch-File in the file "watch.ps1" 
        Watch-File $logging, $progResponse
    }

    <#
    Check and see if the response is "C" 
    If so will change the directory the program will monitor
    #>

    elseif ($response -eq "C".ToUpper()) {
        
        $reply = Write-Settings
        
        if ($reply -eq "A".ToUpper()) { 
            <# Use this to change default directory of files #>
            $file = Request-Directory
        }

        elseif ($reply -eq "B".ToUpper()) {
            <# logging #>
            $logging = Write-Logging
        }

    }

    # Check to see if the response was "exit"
    # This will exit the running program.

    elseif ($response -eq "exit".ToUpper()) {
        Write-Host "Exiting program"
        $Running = $false
    }



    else {
        Write-host "Thats not a valid answer!" -ForegroundColor Red -BackgroundColor White
        Write-host "Please input either 'A' or 'B'"
    }
} # end of while running 