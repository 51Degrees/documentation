<#
.SYNOPSIS
    Commits and pushes documentation changes to gh-pages branch.

.DESCRIPTION
    This script commits the staged documentation changes and pushes them to the 
    gh-pages branch. It should be run after generate-documentation.ps1 which 
    prepares the changes on the gh-pages branch.

.PARAMETER DryRun
    Switch to preview changes without committing or pushing to gh-pages

.PARAMETER CommitMessage
    Custom commit message. If not provided, uses "Update documentation"

.EXAMPLE
    # Commit and push staged changes
    ./update-gh-pages.ps1

.EXAMPLE
    # Preview what would be committed (dry run)
    ./update-gh-pages.ps1 -DryRun

.EXAMPLE
    # Commit with custom message
    ./update-gh-pages.ps1 -CommitMessage "Release 4.6 documentation"
#>
param(
    [switch]$DryRun = $false,
    [string]$CommitMessage = ""
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

# Check if we're on gh-pages branch
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -ne "gh-pages") {
    Write-Host "Error: Not on gh-pages branch (currently on: $currentBranch)"
    Write-Host "Please run generate-documentation.ps1 first, which will switch to gh-pages branch"
    exit 1
}

Write-Host "Current branch: $currentBranch"

# Check if there are staged changes
$stagedChanges = git diff --cached --name-only
if (-not $stagedChanges) {
    Write-Host "No staged changes found. Please run generate-documentation.ps1 first."
    exit 0
}

# Update gh-pages branch
Write-Host "`n========================================"
if ($DryRun) {
    Write-Host "Previewing gh-pages commit (DRY RUN)..."
} else {
    Write-Host "Committing and pushing to gh-pages..."
}
Write-Host "========================================"

if ($DryRun) {
    Write-Host "`n========================================"
    Write-Host "DRY RUN MODE - No changes will be committed"
    Write-Host "========================================"
    
    # Show what would be committed
    Write-Host "`nStaged changes that would be committed:"
    git diff --cached --stat
    Write-Host ""
    git status --short
    
    Write-Host "`nTo commit and push these changes, run without -DryRun flag"
} else {
    # Set commit message
    if (-not $CommitMessage) {
        $CommitMessage = "Update documentation"
    }
    
    # Commit the changes
    Write-Host "Committing changes: $CommitMessage"
    git commit -m $CommitMessage
    
    if ($LASTEXITCODE -eq 0) {
        # Push to origin
        Write-Host "Pushing to origin/gh-pages..."
        git push origin gh-pages
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`nSuccessfully updated gh-pages branch!"
        } else {
            Write-Host "Failed to push to origin/gh-pages"
            Write-Host "You may need to push manually with: git push origin gh-pages"
        }
    } else {
        Write-Host "No changes to commit"
    }
}

Write-Host "`n========================================"
Write-Host "gh-pages update complete!"
Write-Host "========================================"