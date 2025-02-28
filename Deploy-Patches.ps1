# Get user credentials
$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")

# Define paths to CSV configuration files
$ServersListPath = ".\ServersList.csv"
$FileTypesPath = ".\FileTypes.csv"
$FilesToDeployPath = ".\FilesToDeploy.csv"

# Create backup folder with timestamp
$BackupFolderName = "Backup_" + (Get-Date -Format "yyyy-MM-dd_HH-mm-ss")
$LocalBackupPath = ".\$BackupFolderName"
New-Item -ItemType Directory -Path $LocalBackupPath -Force | Out-Null

# Read configuration from CSV files
$Servers = Import-Csv -Path $ServersListPath
$FileTypes = Import-Csv -Path $FileTypesPath
$FilesToDeploy = Import-Csv -Path $FilesToDeployPath

# Loop through each server
foreach ($Server in $Servers) {
    $CurrentServerIP = $Server.IP
    Write-Host "Processing server: $CurrentServerIP" -ForegroundColor Green
    
    try {
        # Create PowerShell session to server
        $session = New-PSSession -ComputerName $CurrentServerIP -Credential $Credential -ErrorAction Stop
        
        # Create server-specific backup folder
        $ServerBackupFolder = Join-Path -Path $LocalBackupPath -ChildPath $CurrentServerIP
        New-Item -ItemType Directory -Path $ServerBackupFolder -Force | Out-Null
        
        # Process each file to deploy
        foreach ($File in $FilesToDeploy) {
            $SourceFilePath = $File.SourcePath
            $FileName = Split-Path -Path $SourceFilePath -Leaf
            $FileTypesList = $File.Types -split ','
            
            Write-Host "  Processing file: $FileName" -ForegroundColor Cyan
            
            # Deploy to multiple locations based on file types
            foreach ($TypeName in $FileTypesList) {
                $TypeName = $TypeName.Trim()
                $TypeInfo = $FileTypes | Where-Object { $_.TypeName -eq $TypeName }
                
                if ($TypeInfo) {
                    $DestinationPath = $TypeInfo.ServerPath
                    $FullDestinationPath = Join-Path -Path $DestinationPath -ChildPath $FileName
                    
                    Write-Host "    Deploying to $DestinationPath (Type: $TypeName)" -ForegroundColor Yellow
                    
                    # Check if file exists on destination before backup
                    $TestPathCommand = "Test-Path -Path '$FullDestinationPath'"
                    $FileExists = Invoke-Command -Session $session -ScriptBlock ([ScriptBlock]::Create($TestPathCommand))
                    
                    if ($FileExists) {
                        # Create backup
                        $BackupFileName = "$FileName.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                        $LocalBackupFilePath = Join-Path -Path $ServerBackupFolder -ChildPath $BackupFileName
                        
                        Write-Host "      Creating backup of existing file" -ForegroundColor DarkYellow
                        Copy-Item -Path $FullDestinationPath -Destination $LocalBackupFilePath -FromSession $session
                    }
                    
                    # Copy new file to destination
                    Write-Host "      Copying new file" -ForegroundColor DarkYellow
                    Copy-Item -Path $SourceFilePath -Destination $DestinationPath -ToSession $session -Force
                } else {
                    Write-Host "    WARNING: Type '$TypeName' not found in configuration" -ForegroundColor Red
                }
            }
        }
        
        # Close the session
        Remove-PSSession $session
        Write-Host "Completed deployment to server: $CurrentServerIP" -ForegroundColor Green
        
    } catch {
        Write-Host "ERROR with server $CurrentServerIP : $_" -ForegroundColor Red
    }
}

Write-Host "Deployment complete. Backups stored in: $LocalBackupPath" -ForegroundColor Green
