<#
.SYNOPSIS
    Generates API documentation for all 51Degrees repositories and updates gh-pages branch.

.DESCRIPTION
    This script clones all necessary repositories, generates documentation using Doxygen
    (extracted from the tools repository), and automatically updates the gh-pages branch 
    with the new documentation unless running in dry-run mode. System requirements are 
    automatically installed on Ubuntu.

.PARAMETER Version
    The version number for the documentation (default: "4.5"). 
    This determines the output directory where documentation is generated.

.PARAMETER GitHubToken
    GitHub token for accessing private repositories (tools). 
    Can also be set via GITHUB_TOKEN environment variable.

.PARAMETER DryRun
    Switch to preview changes without committing or pushing to gh-pages

.EXAMPLE
    # Generate documentation and update gh-pages branch
    ./generate-documentation.ps1 -GitHubToken "ghp_xxxxx"

.EXAMPLE
    # Preview what would be committed (dry run)
    ./generate-documentation.ps1 -DryRun -GitHubToken "ghp_xxxxx"

.EXAMPLE
    # CI environment usage
    ./generate-documentation.ps1 -GitHubToken $env:GITHUB_TOKEN

.EXAMPLE
    # Generate documentation for a different version
    ./generate-documentation.ps1 -Version "4.6" -GitHubToken "ghp_xxxxx"
#>
param(
    [string]$Version = "4.5",
    [string]$GitHubToken = "",
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

# Install system requirements (for CI/Ubuntu environments)
Write-Host "Installing system requirements..." -ForegroundColor Yellow
# Use sudo if available, otherwise run directly (for Docker containers running as root)
$sudoCmd = ""
if (Get-Command sudo -ErrorAction SilentlyContinue) {
    $sudoCmd = "sudo"
}
Invoke-Expression "${sudoCmd} apt-get update"
Invoke-Expression "${sudoCmd} apt-get install -y graphviz flex bison unzip"

# Get GitHub token from parameter or environment
if (-not $GitHubToken) {
    $GitHubToken = $env:GITHUB_TOKEN
    if (-not $GitHubToken) {
        Write-Host "Error: GitHub token is required for cloning private repositories" -ForegroundColor Red
        Write-Host "Please provide -GitHubToken parameter or set GITHUB_TOKEN environment variable" -ForegroundColor Yellow
        exit 1
    }
}

# Clone tools repository first (for Doxygen)
$toolsRepo = "tools"
$toolsPath = Join-Path (Split-Path (Get-Location) -Parent) "tools"

if (-not (Test-Path $toolsPath)) {
    Write-Host "Cloning tools repository..." -ForegroundColor Yellow
    # Use authenticated URL for private repo
    $authenticatedUrl = "https://${GitHubToken}@github.com/51Degrees/tools.git"
    git clone --depth 1 $authenticatedUrl $toolsPath 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone tools repository!" -ForegroundColor Red
        Write-Host "Please check that the GitHub token has access to the tools repository" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "Tools repository cloned successfully" -ForegroundColor Green
} else {
    Write-Host "Tools repository already exists at $toolsPath" -ForegroundColor Green
}

# Extract and setup Doxygen executable
$DoxyGenPath = "$toolsPath/DoxyGen"
$DoxyGenExecutable = "$DoxyGenPath/doxygen-linux"
$DoxyGenZip = "$DoxyGenPath/doxygen-linux.zip"

if (-not (Test-Path $DoxyGenExecutable)) {
    Write-Host "Extracting Doxygen executable..." -ForegroundColor Yellow
    Push-Location $DoxyGenPath
    try {
        if (Test-Path $DoxyGenZip) {
            if ($IsLinux -or $IsMacOS) {
                unzip -o $DoxyGenZip 2>&1 | Out-Null
            } else {
                Expand-Archive -Path $DoxyGenZip -DestinationPath $DoxyGenPath -Force
            }
            Write-Host "Doxygen extracted successfully" -ForegroundColor Green
        } else {
            Write-Host "Doxygen zip file not found at: $DoxyGenZip" -ForegroundColor Red
            exit 1
        }
    } finally {
        Pop-Location
    }
}

# Make Doxygen executable on Unix-like systems
if ($IsMacOS -or $IsLinux) {
    Write-Host "Marking Doxygen as executable..." -ForegroundColor Yellow
    chmod +x $DoxyGenExecutable 2>&1 | Out-Null
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

# Set output directory based on version
$OutputDir = Join-Path (Get-Location) $Version

# Use the extracted doxygen from tools repo
$DoxyGen = $DoxyGenExecutable

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
        & "$PSScriptRoot/generate-api-repo-documentation.ps1" -RepoName $mainRepo -TempDir $tempDir -Version $Version -CurrentBranch $currentBranch -ExamplesRepo $examplesRepo
    } else {
        $repo = $repoItem
        
        # Call helper script for standalone repo
        & "$PSScriptRoot/generate-api-repo-documentation.ps1" -RepoName $repo -TempDir $tempDir -Version $Version -CurrentBranch $currentBranch
    }
}


# Clean up temporary directory
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}

# Update gh-pages branch (always, unless in dry-run mode)
Write-Host "`n========================================" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "Preparing gh-pages branch update (DRY RUN)..." -ForegroundColor Cyan
} else {
    Write-Host "Updating gh-pages branch..." -ForegroundColor Cyan
}
Write-Host "========================================" -ForegroundColor Cyan

# Move the generated documentation to a temporary location
$tempOutputPath = "$OutputDir-new"
if (Test-Path $tempOutputPath) {
    Remove-Item $tempOutputPath -Recurse -Force
}
Move-Item $OutputDir $tempOutputPath -Force

# Check if gh-pages branch exists
$branch = "gh-pages"
Write-Host "Switching to branch '$branch'"
& {
    $PSNativeCommandUseErrorActionPreference = $false
    git show-ref --quiet $branch
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "Creating new orphan branch 'gh-pages'" -ForegroundColor Yellow
    git checkout --force --recurse-submodules --orphan $branch
    git rm -rf .
} else {
    Write-Host "Checking out existing 'gh-pages' branch" -ForegroundColor Yellow
    git checkout --force --recurse-submodules $branch
}

# Remove old version documentation if it exists
if (Test-Path $Version) {
    Write-Host "Removing existing docs in $Version" -ForegroundColor Yellow
    Remove-Item -Recurse -Path $Version
}

# Create .nojekyll file if it doesn't exist (prevents GitHub from processing with Jekyll)
if (!(Test-Path ".nojekyll")) {
    Write-Host "Creating .nojekyll file" -ForegroundColor Yellow
    Write-Output "" > .nojekyll
    git add .nojekyll
}

# Move the new documentation into place
Write-Host "Moving new documentation to $Version" -ForegroundColor Yellow
Move-Item $tempOutputPath $Version

# Stage all changes
Write-Host "Staging documentation changes..." -ForegroundColor Yellow
git add $Version

if ($DryRun) {
    Write-Host "`n========================================" -ForegroundColor Yellow
    Write-Host "DRY RUN MODE - No changes will be committed" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    # Show what would be committed
    Write-Host "`nChanges that would be committed:" -ForegroundColor Cyan
    git status --short
    
    Write-Host "`nTo commit and push these changes, run without -DryRun flag" -ForegroundColor Yellow
    Write-Host "Returning to branch: $currentBranch" -ForegroundColor Yellow
    git checkout $currentBranch
} else {
    # Commit the changes
    $commitMessage = "Update documentation for version $Version"
    Write-Host "Committing changes: $commitMessage" -ForegroundColor Yellow
    git commit -m $commitMessage
    
    if ($LASTEXITCODE -eq 0) {
        # Push to origin
        Write-Host "Pushing to origin/gh-pages..." -ForegroundColor Yellow
        git push origin gh-pages
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`nSuccessfully updated gh-pages branch!" -ForegroundColor Green
        } else {
            Write-Host "Failed to push to origin/gh-pages" -ForegroundColor Red
            Write-Host "You may need to push manually with: git push origin gh-pages" -ForegroundColor Yellow
        }
    } else {
        Write-Host "No changes to commit" -ForegroundColor Yellow
    }
    
    # Return to original branch
    Write-Host "Returning to branch: $currentBranch" -ForegroundColor Yellow
    git checkout $currentBranch
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Documentation generation complete!" -ForegroundColor Green
Write-Host "Output directory: $OutputDir/" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green