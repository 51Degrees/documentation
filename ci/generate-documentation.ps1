param(
    [string]$Version = "4.5",
    [string]$DoxyGen = "",
    [string]$OutputDir = ""
)

# Clone tools repository first (for Doxygen)
$toolsRepo = "tools"
$toolsPath = Join-Path (Split-Path (Get-Location) -Parent) "tools"

if (-not (Test-Path $toolsPath)) {
    Write-Host "Cloning tools repository..." -ForegroundColor Yellow
    git clone --depth 1 "https://github.com/51Degrees/tools.git" $toolsPath 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone tools repository!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Tools repository cloned successfully" -ForegroundColor Green
    # Make Doxygen executable
    if ($IsMacOS -or $IsLinux) {
        chmod +x "$toolsPath/DoxyGen/doxygen-linux" 2>&1 | Out-Null
    }
} else {
    Write-Host "Tools repository already exists at $toolsPath" -ForegroundColor Green
}

# List of repositories to clone and build documentation for
# Format: @{ main = "repo-name"; examples = "examples-repo-name" } or just "standalone-repo-name"
$repositories = @(
    # Device Detection repositories
    "device-detection-cxx",
    @{ main = "device-detection-dotnet"; examples = "device-detection-dotnet-examples" },
    @{ main = "device-detection-java"; examples = "device-detection-java-examples" },
    "device-detection-nginx",
    "device-detection-node",
    "device-detection-php",
    "device-detection-php-onpremise",
    "device-detection-python",
    
    # IP Intelligence repositories
    "ip-intelligence-cxx",
    @{ main = "ip-intelligence-dotnet"; examples = "ip-intelligence-dotnet-examples" },
    "ip-intelligence-go",
    @{ main = "ip-intelligence-java"; examples = "ip-intelligence-java-examples" },
    
    # Location repositories
    "location-dotnet",
    "location-java",
    "location-node",
    "location-php",
    "location-python",
    
    # Pipeline repositories
    "pipeline-dotnet",
    "pipeline-java",
    "pipeline-node",
    "pipeline-python"
)

# Get current branch name
$currentBranch = git rev-parse --abbrev-ref HEAD
Write-Host "Current documentation branch: $currentBranch"

# Determine output directory
if (-not $OutputDir) {
    $OutputDir = Join-Path (Get-Location) $Version
}

# Determine Doxygen executable
if (-not $DoxyGen) {
    # Check if we're in CI environment
    if ($env:CI -eq "true" -or $env:GITHUB_ACTIONS -eq "true") {
        # In CI, use the doxygen from tools repo
        $DoxyGen = "$toolsPath/DoxyGen/doxygen-linux"
    } else {
        Write-Host "Error: DoxyGen parameter is required when not running in CI" -ForegroundColor Red
        Write-Host "Example: -DoxyGen '<command to run doxygen>'" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "Using Doxygen: $DoxyGen"
Write-Host "Output directory: $OutputDir"

# Generate main documentation first
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Generating main documentation..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Push-Location "docs"
try {
    Invoke-Expression "$DoxyGen Doxyfile" 2>&1 | Out-Null
    Write-Host "Main documentation generated successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to generate main documentation: $_" -ForegroundColor Red
    exit 1
} finally {
    Pop-Location
}

# Create directory for cloning repos (for API documentation)
$tempDir = Join-Path (Get-Location) "apis-temp"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

Write-Host "Working in directory: $tempDir"

# Clone documentation repository into temp directory so it's a sibling to other repos
Write-Host "Cloning documentation repository as sibling..."
$docRepoPath = Join-Path $tempDir "documentation"
git clone --depth 1 "https://github.com/51Degrees/documentation.git" $docRepoPath 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to clone documentation repository!" -ForegroundColor Red
    exit 1
}

# Clone and build documentation for each repository
foreach ($repoItem in $repositories) {
    # Handle both standalone repos and main+examples pairs
    if ($repoItem -is [hashtable]) {
        $mainRepo = $repoItem.main
        $examplesRepo = $repoItem.examples
        Write-Host "`n========================================" -ForegroundColor Cyan
        Write-Host "Processing: $mainRepo (with examples: $examplesRepo)" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        
        $repoPath = Join-Path $tempDir $mainRepo
        $mainRepoUrl = "https://github.com/51Degrees/$mainRepo.git"
        $examplesRepoUrl = "https://github.com/51Degrees/$examplesRepo.git"
        
        # Clone main repository
        Write-Host "Cloning $mainRepo..."
        git clone --depth 1 $mainRepoUrl $repoPath 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to clone $mainRepo, skipping..." -ForegroundColor Yellow
            continue
        }
        
        # Clone examples repository inside the main repository
        $examplesPath = Join-Path $repoPath $examplesRepo
        Write-Host "Cloning $examplesRepo into $mainRepo..."
        git clone --depth 1 $examplesRepoUrl $examplesPath 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to clone $examplesRepo, continuing with main repo only..." -ForegroundColor Yellow
        }
        
        $repo = $mainRepo  # Use main repo name for the rest of the processing
    } else {
        $repo = $repoItem
        Write-Host "`n========================================" -ForegroundColor Cyan
        Write-Host "Processing: $repo" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        
        $repoPath = Join-Path $tempDir $repo
        $repoUrl = "https://github.com/51Degrees/$repo.git"
        
        # Clone standalone repository
        Write-Host "Cloning $repo..."
        git clone --depth 1 $repoUrl $repoPath 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to clone $repo, skipping..." -ForegroundColor Yellow
            continue
        }
    }
    
    try {
        # Try to checkout the current branch in main repository
        Push-Location $repoPath
        try {
            # Fetch the specific branch if it exists
            Write-Host "Checking for branch: $currentBranch in $repo"
            git fetch origin $currentBranch`:$currentBranch --depth 1 2>&1 | Out-Null
            
            if ($LASTEXITCODE -eq 0) {
                git checkout $currentBranch 2>&1 | Out-Null
                Write-Host "Switched to branch: $currentBranch" -ForegroundColor Green
            } else {
                Write-Host "Branch $currentBranch not found in $repo, using main/master" -ForegroundColor Yellow
            }
        } finally {
            Pop-Location
        }
        
        # If this is a main+examples pair, also checkout the branch in the examples repo
        if ($repoItem -is [hashtable] -and (Test-Path $examplesPath)) {
            Push-Location $examplesPath
            try {
                Write-Host "Checking for branch: $currentBranch in $($repoItem.examples)"
                git fetch origin $currentBranch`:$currentBranch --depth 1 2>&1 | Out-Null
                
                if ($LASTEXITCODE -eq 0) {
                    git checkout $currentBranch 2>&1 | Out-Null
                    Write-Host "Switched to branch: $currentBranch in examples" -ForegroundColor Green
                } else {
                    Write-Host "Branch $currentBranch not found in examples, using main/master" -ForegroundColor Yellow
                }
            } finally {
                Pop-Location
            }
        }
        
        # Sync submodules after switching to the correct branch
        Push-Location $repoPath
        try {
            Write-Host "Syncing submodules for $repo..."
            git submodule update --init --recursive --depth 1 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Failed to sync submodules for $repo, continuing..." -ForegroundColor Yellow
            }
        } finally {
            Pop-Location
        }
        
        # Create output directory for this repo
        $repoOutputDir = Join-Path $OutputDir "apis" $repo
        if (-not (Test-Path $repoOutputDir)) {
            New-Item -ItemType Directory -Path $repoOutputDir -Force | Out-Null
        }
        
        # Generate documentation by running Doxygen in the docs directory
        $docsDir = Join-Path $repoPath "docs"
        if (-not (Test-Path $docsDir)) {
            Write-Host "No docs directory found for $repo, skipping documentation generation" -ForegroundColor Yellow
            continue
        }
        
        Write-Host "Generating documentation for $repo..."
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
            
            Write-Host "Documentation generated successfully for $repo" -ForegroundColor Green
        } catch {
            Write-Host "Failed to generate documentation for $repo`: $_" -ForegroundColor Red
        } finally {
            Pop-Location
        }
        
    } catch {
        Write-Host "Error processing $repo`: $_" -ForegroundColor Red
    }
}


# Clean up temporary directory (disabled for debug)
# if (Test-Path $tempDir) {
#     Remove-Item $tempDir -Recurse -Force
# }

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Documentation generation complete!" -ForegroundColor Green
Write-Host "Output directory: $OutputDir/" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green