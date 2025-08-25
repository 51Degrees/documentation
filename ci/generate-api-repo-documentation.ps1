param(
    [Parameter(Mandatory=$true)]
    [string]$RepoName,
    
    [Parameter(Mandatory=$true)]
    [string]$TempDir,
    
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$true)]
    [string]$CurrentBranch,
    
    [string]$ExamplesRepo = $null
)

# Determine Doxygen path from tools repository
$toolsPath = Join-Path (Split-Path $TempDir -Parent) "tools"
$DoxyGen = "$toolsPath/DoxyGen/doxygen-linux"

# Calculate output directory based on script location and version
$documentationRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$OutputDir = Join-Path $documentationRoot $Version

# Handle both standalone repos and main+examples pairs
if ($ExamplesRepo) {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Processing: $RepoName (with examples: $ExamplesRepo)" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    $repoPath = Join-Path $TempDir $RepoName
    $mainRepoUrl = "https://github.com/51Degrees/$RepoName.git"
    $examplesRepoUrl = "https://github.com/51Degrees/$ExamplesRepo.git"
    
    # Clone main repository
    Write-Host "Cloning $RepoName..."
    git clone --depth 1 $mainRepoUrl $repoPath 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone $RepoName, skipping..." -ForegroundColor Yellow
        exit 1
    }
    
    # Clone examples repository inside the main repository
    $examplesPath = Join-Path $repoPath $ExamplesRepo
    Write-Host "Cloning $ExamplesRepo into $RepoName..."
    git clone --depth 1 $examplesRepoUrl $examplesPath 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone $ExamplesRepo, continuing with main repo only..." -ForegroundColor Yellow
    }
} else {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Processing: $RepoName" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    $repoPath = Join-Path $TempDir $RepoName
    $repoUrl = "https://github.com/51Degrees/$RepoName.git"
    
    # Clone standalone repository
    Write-Host "Cloning $RepoName..."
    git clone --depth 1 $repoUrl $repoPath 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone $RepoName, skipping..." -ForegroundColor Yellow
        exit 1
    }
}

# Sync submodules for both main and standalone repositories
Push-Location $repoPath
try {
    Write-Host "Syncing submodules for $RepoName..."
    git submodule update --init --recursive --depth 1 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to sync submodules for $RepoName, continuing..." -ForegroundColor Yellow
    }
} finally {
    Pop-Location
}

try {
    # Try to checkout the current branch in main repository
    Push-Location $repoPath
    try {
        # Fetch the specific branch if it exists
        Write-Host "Checking for branch: $CurrentBranch in $RepoName"
        git fetch origin $CurrentBranch`:$CurrentBranch --depth 1 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            git checkout $CurrentBranch 2>&1 | Out-Null
            Write-Host "Switched to branch: $CurrentBranch" -ForegroundColor Green
        } else {
            Write-Host "Branch $CurrentBranch not found in $RepoName, using main/master" -ForegroundColor Yellow
        }
    } finally {
        Pop-Location
    }
    
    # If this is a main+examples pair, also checkout the branch in the examples repo
    if ($ExamplesRepo -and (Test-Path $examplesPath)) {
        Push-Location $examplesPath
        try {
            Write-Host "Checking for branch: $CurrentBranch in $ExamplesRepo"
            git fetch origin $CurrentBranch`:$CurrentBranch --depth 1 2>&1 | Out-Null
            
            if ($LASTEXITCODE -eq 0) {
                git checkout $CurrentBranch 2>&1 | Out-Null
                Write-Host "Switched to branch: $CurrentBranch in examples" -ForegroundColor Green
            } else {
                Write-Host "Branch $CurrentBranch not found in examples, using main/master" -ForegroundColor Yellow
            }
        } finally {
            Pop-Location
        }
    }
    
    # Sync submodules after switching to the correct branch
    Push-Location $repoPath
    try {
        Write-Host "Syncing submodules for $RepoName..."
        git submodule update --init --recursive --depth 1 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to sync submodules for $RepoName, continuing..." -ForegroundColor Yellow
        }
    } finally {
        Pop-Location
    }
    
    # Create output directory for this repo
    $repoOutputDir = Join-Path $OutputDir "apis" $RepoName
    if (-not (Test-Path $repoOutputDir)) {
        New-Item -ItemType Directory -Path $repoOutputDir -Force | Out-Null
    }
    
    # Generate documentation by running Doxygen in the docs directory
    $docsDir = Join-Path $repoPath "docs"
    if (-not (Test-Path $docsDir)) {
        Write-Host "No docs directory found for $RepoName, skipping documentation generation" -ForegroundColor Yellow
        exit 0
    }
    
    Write-Host "Generating documentation for $RepoName..."
    Push-Location $docsDir
    try {
        Write-Host "Running Doxygen in: $(Get-Location)" -ForegroundColor Yellow
        
        $exitCode = 0
        try {
            & $DoxyGen
            $exitCode = $LASTEXITCODE
        } catch {
            Write-Host "Error running Doxygen: $_" -ForegroundColor Red
            $exitCode = 1
        }
        
        if ($exitCode -ne 0) {
            Write-Host "Doxygen failed with exit code $exitCode" -ForegroundColor Red
        } else {
            Write-Host "Doxygen completed successfully" -ForegroundColor Green
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
                    Write-Host "Found generated documentation: $sourceDir" -ForegroundColor Green
                    break
                }
            }
        }
        
        if ($sourceDir) {
            # Create target directory and copy files
            if (-not (Test-Path $repoOutputDir)) {
                New-Item -ItemType Directory -Path $repoOutputDir -Force | Out-Null
            }
            
            # Copy all HTML files to our target directory
            Copy-Item -Path "$sourceDir/*" -Destination $repoOutputDir -Recurse -Force
            
            $htmlFiles = Get-ChildItem -Path $repoOutputDir -Filter "*.html" -Recurse
            Write-Host "Copied $($htmlFiles.Count) HTML files to $repoOutputDir" -ForegroundColor Yellow
            $htmlFiles | Select-Object -First 10 | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Green }
        } else {
            Write-Host "No generated documentation found in expected locations" -ForegroundColor Red
        }
        
        Write-Host "Documentation generated successfully for $RepoName" -ForegroundColor Green
    } catch {
        Write-Host "Failed to generate documentation for $RepoName`: $_" -ForegroundColor Red
        exit 1
    } finally {
        Pop-Location
    }
    
} catch {
    Write-Host "Error processing $RepoName`: $_" -ForegroundColor Red
    exit 1
}