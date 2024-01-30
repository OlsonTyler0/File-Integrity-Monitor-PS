
function Request-Choices() {
    # Write the initial choices to the console
    Write-Host ""
    Write-Host "What would you like to do?"
    Write-Host "A) Collect new baseline"
    Write-Host "B) Begin monitoring files with saved baseline"
    Write-Host "C) Change Settings"
    Write-Host "exit) exit program"
    $response = Read-Host -Prompt "Please enter 'A' or 'B'"
    Write-Host ""
    return $response
}

# Measure-File-Hash gathers the file hash
# for the file placed in the arguement

function Measure-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
    
}


# This function is done to clear the baseline 
# if it exists.

function Clear-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path .\baseline.txt
    if($baselineExists) {
        # Delete the baseline
        Remove-Item -Path .\baseline.txt
    }
}

function Request-Directory () {

    # Use this to change default directory of files
    $run = $true
    while ($run) {
        $reply = Read-Host -Prompt "What is the file path you would like to use?"
        if (Test-Path -Path $reply) {
            Write-Host "File successfully inputed." -ForegroundColor Green
            return $reply
        }
        elseif ($reply -eq "exit".ToUpper()) {
            $run = $false
        }
        else {
            Write-Host "Error, File not valid please try again"
        }
    }
}