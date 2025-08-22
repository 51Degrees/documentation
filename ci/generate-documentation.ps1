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
        
        # Call helper script for main+examples repo
        & "$PSScriptRoot/generate-api-repo-documentation.ps1" -RepoName $mainRepo -TempDir $tempDir -OutputDir $OutputDir -DoxyGen $DoxyGen -CurrentBranch $currentBranch -ExamplesRepo $examplesRepo
    } else {
        $repo = $repoItem
        
        # Call helper script for standalone repo
        & "$PSScriptRoot/generate-api-repo-documentation.ps1" -RepoName $repo -TempDir $tempDir -OutputDir $OutputDir -DoxyGen $DoxyGen -CurrentBranch $currentBranch
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