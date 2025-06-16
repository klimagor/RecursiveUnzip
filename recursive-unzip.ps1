param (
    [string]$zipPath
)

# 7-zip executable path - adjust if needed
$7zipPath = "C:\Program Files\7-Zip\7z.exe"

# Check if 7-zip is installed
if (-not (Test-Path $7zipPath)) {
    # Try alternative common locations
    $altPaths = @(
        "C:\Program Files (x86)\7-Zip\7z.exe",
        "${env:ProgramFiles}\7-Zip\7z.exe",
        "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
    )
    
    $found = $false
    foreach ($path in $altPaths) {
        if (Test-Path $path) {
            $7zipPath = $path
            $found = $true
            break
        }
    }
    
    if (-not $found) {
        Write-Error "7-zip not found. Please install 7-zip or adjust the path in the script."
        exit 1
    }
}

function UnzipFile($zipFile, $destination) {
    # Create destination directory if it doesn't exist
    if (-not (Test-Path $destination)) {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
    }
    
    # Use 7-zip to extract with UTF-8 support
    $arguments = @(
        "x",                    # Extract command
        "`"$zipFile`"",        # Source zip file (quoted for spaces)
        "-o`"$destination`"",  # Output directory (quoted for spaces)
        "-y"                   # Yes to all prompts
    )
    
    $process = Start-Process -FilePath $7zipPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -ne 0) {
        throw "7-zip extraction failed with exit code $($process.ExitCode)"
    }
}

function UnzipAllZips($folder) {
    $zipFiles = Get-ChildItem -Path $folder -Recurse -Filter *.zip | Sort-Object FullName
    
    foreach ($zip in $zipFiles) {
        $target = "$($zip.DirectoryName)\$($zip.BaseName)"
        
        try {
            Write-Host "Extracting: $($zip.FullName)"
            UnzipFile $zip.FullName $target
            Remove-Item $zip.FullName -Force
            Write-Host "Successfully extracted and removed: $($zip.Name)"
        } catch {
            Write-Warning "Failed to unzip $($zip.FullName): $_"
        }
    }
    
    # Run again if deeper nested ZIPs were extracted
    if ((Get-ChildItem -Path $folder -Recurse -Filter *.zip).Count -gt 0) {
        Write-Host "Found more nested ZIP files, continuing recursion..."
        UnzipAllZips $folder
    }
}

# Validate input
if (-not $zipPath -or -not (Test-Path $zipPath)) {
    Write-Error "Please provide a valid ZIP file path."
    exit 1
}

# Initial unzip
$destination = "$($zipPath)_extracted"
Write-Host "Starting extraction of main ZIP file to: $destination"

try {
    UnzipFile $zipPath $destination
    Write-Host "Main ZIP file extracted successfully."
    
    # Recursive unzip and cleanup
    Write-Host "Starting recursive extraction of nested ZIP files..."
    UnzipAllZips $destination
    
    Write-Host "Recursive extraction completed successfully!"
} catch {
    Write-Error "Error during extraction: $_"
    exit 1
}