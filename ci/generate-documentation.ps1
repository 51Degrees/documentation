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
    [string]$GitHubToken = "",
    [switch]$DryRun = $false
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

# Clone all necessary repositories upfront for early failure detection
Write-Host "========================================"
Write-Host "Cloning necessary repositories..."
Write-Host "========================================"

# Clone tools repository first (for Doxygen)
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

# Clone common-ci repository (for git configuration)
$commonCiPath = Join-Path (Split-Path (Get-Location) -Parent) "common-ci"
if (-not (Test-Path $commonCiPath)) {
    Write-Host "Cloning common-ci repository..."
    git clone --depth 1 "https://github.com/postindustria-tech/common-ci.git" $commonCiPath 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone common-ci repository!"
        exit 1
    }
    Write-Host "Common-ci repository cloned successfully"
} else {
    Write-Host "Common-ci repository already exists at $commonCiPath"
}

# Configure git using common-ci script early so all subsequent clones use the token
Write-Host "Configuring git for authenticated operations..."
& "$commonCiPath/steps/configure-git.ps1" -GitHubToken $GitHubToken

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


# Store the original branch
$originalBranch = git rev-parse --abbrev-ref HEAD
Write-Host "Original branch: $originalBranch"

# Move the generated documentation to a temporary location
$tempOutputPath = "$OutputDir-new"
if (Test-Path $tempOutputPath) {
    Remove-Item $tempOutputPath -Recurse -Force
}
Write-Host "Moving documentation to temporary location..."
Move-Item $OutputDir $tempOutputPath -Force

Write-Host "`n========================================"
Write-Host "Switching to gh-pages branch and staging changes..."
Write-Host "========================================"

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
    & {
        $PSNativeCommandUseErrorActionPreference = $false
        git commit -m "Add .nojekyll file" 2>&1 | Out-Null
    }
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

# Check for changes, commit and push using common-ci scripts
Write-Host "`n========================================"
Write-Host "Checking for changes..."
Write-Host "========================================"

# Check if there are changes to commit
& "$commonCiPath/steps/has-changed.ps1" -RepoName "."

if ($LASTEXITCODE -eq 0) {
    # There are changes to commit
    if ($DryRun) {
        Write-Host "`n========================================"
        Write-Host "DRY RUN MODE - No changes will be committed"
        Write-Host "========================================"
        
        # Show what would be committed
        Write-Host "`nStaged changes that would be committed:"
        git status --porcelain
        
        Write-Host "`nTo commit and push these changes, run without -DryRun flag"
    } else {
        # Set commit message
        $CommitMessage = "Update documentation for version $Version"
        
        Write-Host "`n========================================"
        Write-Host "Committing and pushing to gh-pages..."
        Write-Host "========================================"
        
        # Commit the changes using common-ci script
        & "$commonCiPath/steps/commit-changes.ps1" -RepoName "." -Message $CommitMessage
        
        if ($LASTEXITCODE -eq 0) {
            # Push to origin using common-ci script
            & "$commonCiPath/steps/push-changes.ps1" -RepoName "." -Force $false -DryRun $false
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "`nSuccessfully updated gh-pages branch!"
            } else {
                Write-Host "Failed to push to origin/gh-pages"
                Write-Host "You may need to push manually with: git push origin gh-pages"
            }
        } else {
            Write-Host "Failed to commit changes"
        }
    }
} else {
    Write-Host "No changes to commit"
}

Write-Host "`n========================================"
Write-Host "Documentation generation and gh-pages update complete!"
Write-Host "========================================"

# Return to original branch
Write-Host "Returning to original branch: $originalBranch"
git checkout $originalBranch