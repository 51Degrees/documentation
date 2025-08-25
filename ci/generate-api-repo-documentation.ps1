param(
    [Parameter(Mandatory=$true)]
    [string]$RepoName,
    
    [Parameter(Mandatory=$true)]
    [string]$TempDir,
    
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$true)]
    [string]$CurrentBranch,
    
    [Parameter(Mandatory=$true)]
    [string]$CommonCiPath,
    
    [string]$ExamplesRepo = $null,
    [switch]$ShowDoxygenOutput = $false
)

# Include common helper functions
. "$PSScriptRoot/common-helpers.ps1"

# Determine Doxygen path from tools repository
# TempDir is /media/51drepos/documentation/apis-temp
# Tools is at /media/51drepos/tools (sibling to documentation directory)
$documentationDir = Split-Path $TempDir -Parent  # /media/51drepos/documentation
$parentDir = Split-Path $documentationDir -Parent  # /media/51drepos
$toolsPath = Join-Path $parentDir "tools"  # /media/51drepos/tools
$DoxyGen = "$toolsPath/DoxyGen/doxygen-linux"

# Calculate output directory based on script location and version
# PSScriptRoot is /media/51drepos/documentation/ci
# We want /media/51drepos/documentation/4.5
$documentationRoot = Split-Path $PSScriptRoot -Parent  # /media/51drepos/documentation
$OutputDir = Join-Path $documentationRoot $Version     # /media/51drepos/documentation/4.5

# Helper function to clone repository with proper branch fallback
function Clone-Repository {
    param(
        [string]$RepoName,
        [string]$DestinationDir,
        [string]$Branch
    )
    
    Push-Location $DestinationDir
    try {
        $repoUrl = "https://github.com/51Degrees/$RepoName.git"
        
        Write-Host "Cloning $RepoName..."
        
        # Try to clone with the specific branch first
        & {
            $PSNativeCommandUseErrorActionPreference = $false
            git clone --depth 1 --branch $Branch $repoUrl $RepoName 2>&1 | Out-Null
        }
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Branch $Branch not found, trying main branch..."
            
            # Try main branch
            & {
                $PSNativeCommandUseErrorActionPreference = $false
                git clone --depth 1 --branch main $repoUrl $RepoName 2>&1 | Out-Null
            }
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Main branch not found, trying master branch..."
                
                # Try master branch
                & {
                    $PSNativeCommandUseErrorActionPreference = $false
                    git clone --depth 1 --branch master $repoUrl $RepoName 2>&1 | Out-Null
                }
                
                if ($LASTEXITCODE -ne 0) {
                    Write-Host "Failed to clone $RepoName with any branch"
                    return $false
                }
            }
        }
        
        # Initialize submodules if they exist, but don't fail if they don't work
        Push-Location $RepoName
        try {
            & {
                $PSNativeCommandUseErrorActionPreference = $false
                git submodule update --init --recursive --depth 1 2>&1 | Out-Null
            }
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Failed to sync submodules for $RepoName, continuing without them..."
            }
        } finally {
            Pop-Location
        }
        
        return $true
    } finally {
        Pop-Location
    }
}

# Handle both standalone repos and main+examples pairs
if ($ExamplesRepo) {
    Write-Host "`n========================================"
    Write-Host "Processing: $RepoName (with examples: $ExamplesRepo)"
    Write-Host "========================================"
    
    # Clone main repository
    if (-not (Clone-Repository -RepoName $RepoName -DestinationDir $TempDir -Branch $CurrentBranch)) {
        Write-Host "Failed to clone $RepoName, skipping..."
        exit 1
    }
    
    $repoPath = Join-Path $TempDir $RepoName
    
    # Clone examples repository inside the main repository
    if (-not (Clone-Repository -RepoName $ExamplesRepo -DestinationDir $repoPath -Branch $CurrentBranch)) {
        Write-Host "Failed to clone $ExamplesRepo, continuing with main repo only..."
    }
} else {
    Write-Host "`n========================================"
    Write-Host "Processing: $RepoName"
    Write-Host "========================================"
    
    # Clone standalone repository
    if (-not (Clone-Repository -RepoName $RepoName -DestinationDir $TempDir -Branch $CurrentBranch)) {
        Write-Host "Failed to clone $RepoName, skipping..."
        exit 1
    }
    
    $repoPath = Join-Path $TempDir $RepoName
}

# Repository is now cloned and ready for documentation generation
# The common-ci clone-repo.ps1 script has already:
# - Cloned the repository with recursive submodules
# - Switched to the correct branch (with fallback to main)
# - Synced all submodules properly

try {
    # Create output directory for this repo
    $repoOutputDir = Join-Path $OutputDir "apis" $RepoName
    if (-not (Test-Path $repoOutputDir)) {
        New-Item -ItemType Directory -Path $repoOutputDir -Force | Out-Null
    } else {
    }
    
    # Generate documentation by running Doxygen in the docs directory
    $docsDir = Join-Path $repoPath "docs"
    if (-not (Test-Path $docsDir)) {
        Write-Host "No docs directory found for $RepoName, skipping documentation generation"
        exit 0
    }
    
    Write-Host "Generating documentation for $RepoName..."
    Push-Location $docsDir
    try {
        Write-Host "Running Doxygen in: $(Get-Location)"
        
        $exitCode = 0
        try {
            $exitCode = Invoke-Doxygen -DoxygenPath $DoxyGen -ShowDoxygenOutput:$ShowDoxygenOutput
        } catch {
            Write-Host "Error running Doxygen: $_"
            $exitCode = 1
        }
        
        if ($exitCode -ne 0) {
            Write-Host "Doxygen failed with exit code $exitCode"
        } else {
            Write-Host "Doxygen completed successfully"
        }
        
        # Look for generated documentation in the temp repository
        $possibleOutputDirs = @(
            (Join-Path $repoPath "4.5"),
            (Join-Path $repoPath "4.4")
        )
        
        
        $sourceDir = $null
        foreach ($dir in $possibleOutputDirs) {
            if (Test-Path $dir) {
                $htmlFiles = Get-ChildItem -Path $dir -Filter "*.html" -Recurse
                if ($htmlFiles.Count -gt 0) {
                    $sourceDir = $dir
                    Write-Host "Found generated documentation: $sourceDir"
                    break
                }
            }
        }
        
        if ($sourceDir) {
            
            # Create target directory and copy files
            if (-not (Test-Path $repoOutputDir)) {
                New-Item -ItemType Directory -Path $repoOutputDir -Force | Out-Null
            } else {
            }
            
            # Copy all HTML files to our target directory
            Copy-Item -Path "$sourceDir/*" -Destination $repoOutputDir -Recurse -Force
            
            $htmlFiles = Get-ChildItem -Path $repoOutputDir -Filter "*.html" -Recurse
            Write-Host "Copied $($htmlFiles.Count) HTML files to $repoOutputDir"
            $htmlFiles | Select-Object -First 10 | ForEach-Object { Write-Host "  $($_.Name)" }
            
        } else {
            Write-Host "No generated documentation found in expected locations"
        }
        
        Write-Host "Documentation generated successfully for $RepoName"
    } catch {
        Write-Host "Failed to generate documentation for $RepoName`: $_"
        exit 1
    } finally {
        Pop-Location
    }
    
} catch {
    Write-Host "Error processing $RepoName`: $_"
    exit 1
}