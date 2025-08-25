<#
.SYNOPSIS
    Generates API documentation for all 51Degrees repositories.

.DESCRIPTION
    This script clones all necessary repositories and generates documentation using Doxygen
    (extracted from the tools repository). System requirements are automatically installed 
    on Ubuntu. To update gh-pages branch after generation, use update-gh-pages.ps1.

.PARAMETER Version
    The version number for the documentation (default: "4.5"). 
    This determines the output directory where documentation is generated.

.PARAMETER GitHubToken
    GitHub token for accessing private repositories (tools). 
    Can also be set via GITHUB_TOKEN environment variable.

.EXAMPLE
    # Generate documentation
    ./generate-documentation.ps1 -GitHubToken "ghp_xxxxx"

.EXAMPLE
    # CI environment usage
    ./generate-documentation.ps1 -GitHubToken $env:GITHUB_TOKEN

.EXAMPLE
    # Generate documentation for a different version
    ./generate-documentation.ps1 -Version "4.6" -GitHubToken "ghp_xxxxx"

.EXAMPLE
    # Generate and then update gh-pages
    ./generate-documentation.ps1 -GitHubToken "ghp_xxxxx"
    ./update-gh-pages.ps1
#>
param(
    [string]$Version = "4.5",
    [string]$GitHubToken = ""
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

# Install system requirements (for CI/Ubuntu environments)
Write-Host "Installing system requirements..."
# Use sudo if available, otherwise run directly (for Docker containers running as root)
$sudoCmd = ""
if (Get-Command sudo -ErrorAction SilentlyContinue) {
    $sudoCmd = "sudo "
}
Invoke-Expression "${sudoCmd}apt-get update"
Invoke-Expression "${sudoCmd}apt-get install -y graphviz flex bison unzip"

# Get GitHub token from parameter or environment
if (-not $GitHubToken) {
    $GitHubToken = $env:GITHUB_TOKEN
    if (-not $GitHubToken) {
        Write-Host "Error: GitHub token is required for cloning private repositories"
        Write-Host "Please provide -GitHubToken parameter or set GITHUB_TOKEN environment variable"
        exit 1
    }
}

# Clone tools repository first (for Doxygen)
$toolsRepo = "tools"
$toolsPath = Join-Path (Split-Path (Get-Location) -Parent) "tools"

if (-not (Test-Path $toolsPath)) {
    Write-Host "Cloning tools repository..."
    # Use authenticated URL for private repo
    $authenticatedUrl = "https://${GitHubToken}@github.com/51Degrees/tools.git"
    git clone --depth 1 $authenticatedUrl $toolsPath 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone tools repository!"
        Write-Host "Please check that the GitHub token has access to the tools repository"
        exit 1
    }
    Write-Host "Tools repository cloned successfully"
} else {
    Write-Host "Tools repository already exists at $toolsPath"
}

# Extract and setup Doxygen executable
$DoxyGenPath = "$toolsPath/DoxyGen"
$DoxyGenExecutable = "$DoxyGenPath/doxygen-linux"
$DoxyGenZip = "$DoxyGenPath/doxygen-linux.zip"

if (-not (Test-Path $DoxyGenExecutable)) {
    Write-Host "Extracting Doxygen executable..."
    Push-Location $DoxyGenPath
    try {
        if (Test-Path $DoxyGenZip) {
            if ($IsLinux -or $IsMacOS) {
                unzip -o $DoxyGenZip 2>&1 | Out-Null
            } else {
                Expand-Archive -Path $DoxyGenZip -DestinationPath $DoxyGenPath -Force
            }
            Write-Host "Doxygen extracted successfully"
        } else {
            Write-Host "Doxygen zip file not found at: $DoxyGenZip"
            exit 1
        }
    } finally {
        Pop-Location
    }
}

# Make Doxygen executable on Unix-like systems
if ($IsMacOS -or $IsLinux) {
    Write-Host "Marking Doxygen as executable..."
    chmod +x $DoxyGenExecutable 2>&1 | Out-Null
}

# List of repositories to clone and build documentation for
# Format: @{ main = "repo-name"; examples = "examples-repo-name" } or just "standalone-repo-name"
$repositories = @(
    # Device Detection repositories
    "device-detection-cxx",
    @{ main = "device-detection-dotnet"; examples = "device-detection-dotnet-examples"},
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
Write-Host "`n========================================"
Write-Host "Generating main documentation..."
Write-Host "========================================"

Push-Location "docs"
try {
    Invoke-Expression "$DoxyGen Doxyfile"
    Write-Host "Main documentation generated successfully"
} catch {
    Write-Host "Failed to generate main documentation: $_"
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
Write-Host "Cloning documentation repository as sibling on branch: $currentBranch..."
$docRepoPath = Join-Path $tempDir "documentation"
git clone --depth 1 --branch $currentBranch "https://github.com/51Degrees/documentation.git" $docRepoPath 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to clone documentation repository on branch $currentBranch, trying main branch..."
    git clone --depth 1 "https://github.com/51Degrees/documentation.git" $docRepoPath 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone documentation repository!"
        exit 1
    }
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

Write-Host "`n========================================"
Write-Host "Documentation generation complete!"
Write-Host "Generated in: $OutputDir/"
Write-Host "========================================"


# Now checkout gh-pages branch and stage the generated documentation
Write-Host "`n========================================"
Write-Host "Switching to gh-pages branch and staging changes..."
Write-Host "========================================"

# Move the generated documentation to a temporary location
$tempOutputPath = "$OutputDir-new"
if (Test-Path $tempOutputPath) {
    Remove-Item $tempOutputPath -Recurse -Force
}
Write-Host "Moving documentation to temporary location..."
Move-Item $OutputDir $tempOutputPath -Force

# Check if gh-pages branch exists
$branch = "gh-pages"
Write-Host "Switching to branch '$branch'"
& {
    $PSNativeCommandUseErrorActionPreference = $false
    git show-ref --quiet $branch
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "Creating new orphan branch 'gh-pages'"
    git checkout --force --recurse-submodules --orphan $branch
    git rm -rf .
} else {
    Write-Host "Checking out existing 'gh-pages' branch"
    git checkout --force --recurse-submodules $branch
}

# Remove old version documentation if it exists
if (Test-Path $Version) {
    Write-Host "Removing existing docs in $Version"
    Remove-Item -Recurse -Path $Version
}

# Create .nojekyll file if it doesn't exist (prevents GitHub from processing with Jekyll)
if (!(Test-Path ".nojekyll")) {
    Write-Host "Creating .nojekyll file"
    Write-Output "" > .nojekyll
    git add .nojekyll
    git commit -m "Add .nojekyll file" 2>&1 | Out-Null
}

# Move the new documentation into place
Write-Host "Moving new documentation to $Version"
if (Test-Path $tempOutputPath) {
    Move-Item $tempOutputPath $Version
    Write-Host "Successfully moved documentation from $tempOutputPath to $Version"
} else {
    Write-Host "ERROR: Temporary documentation path not found: $tempOutputPath"
    exit 1
}

# Stage all changes
Write-Host "Staging documentation changes..."
git add $Version

Write-Host "`n========================================"
Write-Host "Documentation staged on gh-pages branch!"
Write-Host "========================================"
Write-Host ""
Write-Host "Changes are staged and ready. To commit and push:"
Write-Host "  ./ci/update-gh-pages.ps1"
Write-Host ""
Write-Host "For dry run (preview changes):"
Write-Host "  ./ci/update-gh-pages.ps1 -DryRun"
Write-Host ""
Write-Host "To return to original branch:"
Write-Host "  git checkout $currentBranch"