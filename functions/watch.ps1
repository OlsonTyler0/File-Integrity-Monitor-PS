
function Watch-File ($logging, $response) {
  # Define the variables to be used in this function
    $fileHashDictionary = @{}
    $AlertDictionary = @{}

    #Notify the user the program has started looping and how to exit
    Write-Host "Starting the monitoring program. Stop the program with 'Ctrl +C'" -ForegroundColor Green

    
    #load file|hash from baseline.txt and store in the dictionary
    $filePathsAndHashes = Get-Content -Path .\baseline.txt
    foreach ($f in $filePathsAndHashes) {
      $fileHashDictionary.add($f.Split("|")[0].Trim(), $f.Split("|")[1].Trim())
    }

    #Watch loop starts
    while ($true) {
      Start-Sleep -Seconds 1
      $files = Get-ChildItem -Path .\files

      # for each file, calculate the hash and write to baseline.txt
        foreach ($f in $files) {
         $hash = Measure-File-Hash $f.FullName

          #notify if a new file has been created
          if ($null -eq $fileHashDictionary[$hash.Path]) {
            # A new file has been created
            Write-Host "$($hash.Path) has been created!" -ForegroundColor Green

            # Adds to the directory to avoid repeat hits
            $fileHashDictionary.add($hash.Path, $Hash.Hash)

            #If logging adds it to the log
            if ($logging -eq $true) {
                "$(Get-Date -Format o) | $($hash.Path) has been created!" | Out-File -FilePath .\log.txt -Append
            }
          }

            #If file exists in the database already, it will run other checks
            # otherwise it will exit and move to the next loop.
  
            else {
                 # Check to see if the hash does not match hash stored
                if ($fileHashDictionary[$hash.Path] -eq $($hash.Hash)) {
                    # Path has not changed nothing will occur
                  }

                else {
                    # file has been comprimised!
                    Write-Host "$($hash.Path) Has been changed!" -ForegroundColor Yellow

                    # Adds to the directory to avoid repeat hits
                    $fileHashDictionary[$hash.Path] = $hash.Hash

                    if ($logging -eq $true) {
                      "$(Get-Date -Format o) | $($hash.Path) has been changed!" | Out-File -FilePath .\log.txt -Append
                    }
                  }
                }
                
              # Notify if a file has been deleted
                
              foreach ($key in $fileHashDictionary.Keys) {
                $baselineFileStillExists = Test-Path -Path $key
                if ((-Not $baselineFileStillExists) -and ($null -eq $AlertDictionary[$key])) {
                    #One of the baseline files have been deleted notify user
                    Write-Host "$($key) has been deleted!" -ForegroundColor DarkMagenta

                    $AlertDictionary[$key] = $fileHashDictionary[$key]

                    if ($logging -eq $true) {
                      "$(Get-Date -Format o) | $($key) has been deleted!" | Out-File -FilePath .\log.txt -Append
                  }
                }
            } # stopping looping through keys
        } # end of loop through files
    } # End of while
  } # End of Watch-File function