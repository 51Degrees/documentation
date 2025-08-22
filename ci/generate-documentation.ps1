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
    @{ main = "device-detection-dotnet"; examples = "device-detection-dotnet-examples" },
    @{ main = "device-detection-java"; examples = "device-detection-java-examples" },
    @{ main = "ip-intelligence-dotnet"; examples = "ip-intelligence-dotnet-examples" },
    @{ main = "ip-intelligence-java"; examples = "ip-intelligence-java-examples" },
    "device-detection-python",
    "device-detection-node", 
    "device-detection-php",
    "pipeline-dotnet",
    "pipeline-java",
    "pipeline-node",
    "pipeline-php-core"
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
        
        # Clone examples repository as sibling directory (expected by Doxyfiles)
        $examplesPath = Join-Path $tempDir $examplesRepo
        Write-Host "Cloning $examplesRepo as sibling to $mainRepo..."
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
        
        # Look for Doxyfile in common locations
        $doxyfilePaths = @(
            (Join-Path $repoPath "docs/Doxyfile"),
            (Join-Path $repoPath "Doxyfile"),
            (Join-Path $repoPath "doc/Doxyfile")
        )
        
        $doxyfile = $null
        foreach ($path in $doxyfilePaths) {
            if (Test-Path $path) {
                $doxyfile = $path
                break
            }
        }
        
        if (-not $doxyfile) {
            Write-Host "No Doxyfile found for $repo, skipping documentation generation" -ForegroundColor Yellow
            continue
        }
        
        Write-Host "Found Doxyfile at: $doxyfile"
        
        # Create output directory for this repo
        $repoOutputDir = Join-Path $OutputDir "apis" $repo
        if (-not (Test-Path $repoOutputDir)) {
            New-Item -ItemType Directory -Path $repoOutputDir -Force | Out-Null
        }
        
        # Generate documentation
        Write-Host "Generating documentation for $repo..."
        
        # Create symlinks to documentation directory so relative paths work
        $doxyParentDir = Split-Path $doxyfile -Parent
        # From docs directory, path ../../documentation should point to main documentation
        $expectedDocPath = Join-Path (Split-Path (Split-Path $doxyParentDir -Parent) -Parent) "documentation"
        
        if (-not (Test-Path $expectedDocPath)) {
            Write-Host "Creating symlink to documentation directory at: $expectedDocPath" -ForegroundColor Yellow
            # Create the directory structure if it doesn't exist
            $parentPath = Split-Path $expectedDocPath -Parent
            if (-not (Test-Path $parentPath)) {
                New-Item -ItemType Directory -Path $parentPath -Force | Out-Null
            }
            # On Linux, we can create a symbolic link
            $currentDocPath = "/media/51drepos/documentation"
            New-Item -ItemType SymbolicLink -Path $expectedDocPath -Target $currentDocPath -Force | Out-Null
        }
        
        Push-Location (Split-Path $doxyfile -Parent)
        try {
            # Run Doxygen with original configuration (don't modify OUTPUT_DIRECTORY)
            $doxyfileName = Split-Path $doxyfile -Leaf
            Write-Host "Running Doxygen..." -ForegroundColor Yellow
            
            # Modify Doxyfile to use absolute paths for documentation assets
            $tempDoxyfile = "Doxyfile.temp"
            $absoluteDocPath = "/media/51drepos/documentation"
            Get-Content $doxyfileName | ForEach-Object {
                if ($_ -match "HTML_HEADER\s*=\s*(.*)") {
                    $relativePath = $matches[1].Trim().Trim('"')
                    if ($relativePath.StartsWith("../../documentation/")) {
                        $newPath = $relativePath -replace "../../documentation/", "$absoluteDocPath/"
                        "HTML_HEADER = `"$newPath`""
                        Write-Host "Modified HTML_HEADER: $relativePath -> $newPath" -ForegroundColor Green
                    } else {
                        $_
                    }
                } elseif ($_ -match "HTML_FOOTER\s*=\s*(.*)") {
                    $relativePath = $matches[1].Trim().Trim('"')
                    if ($relativePath.StartsWith("../../documentation/")) {
                        $newPath = $relativePath -replace "../../documentation/", "$absoluteDocPath/"
                        "HTML_FOOTER = `"$newPath`""
                        Write-Host "Modified HTML_FOOTER: $relativePath -> $newPath" -ForegroundColor Green
                    } else {
                        $_
                    }
                } elseif ($_ -match "HTML_STYLESHEET\s*=\s*(.*)") {
                    $relativePath = $matches[1].Trim().Trim('"')
                    if ($relativePath.StartsWith("../../documentation/")) {
                        $newPath = $relativePath -replace "../../documentation/", "$absoluteDocPath/"
                        "HTML_STYLESHEET = `"$newPath`""
                        Write-Host "Modified HTML_STYLESHEET: $relativePath -> $newPath" -ForegroundColor Green
                    } else {
                        $_
                    }
                } else {
                    $_
                }
            } | Out-File $tempDoxyfile -Encoding UTF8

            # Use Start-Process to capture output properly
            $pinfo = New-Object System.Diagnostics.ProcessStartInfo
            $pinfo.FileName = $DoxyGen
            $pinfo.Arguments = (Resolve-Path $tempDoxyfile).Path
            $pinfo.RedirectStandardOutput = $true
            $pinfo.RedirectStandardError = $true
            $pinfo.UseShellExecute = $false
            $pinfo.CreateNoWindow = $true
            
            $process = New-Object System.Diagnostics.Process
            $process.StartInfo = $pinfo
            $process.Start() | Out-Null
            $process.WaitForExit()
            
            $stdout = $process.StandardOutput.ReadToEnd()
            $stderr = $process.StandardError.ReadToEnd()
            $exitCode = $process.ExitCode
            
            Write-Host "Doxygen stdout:" -ForegroundColor Yellow
            Write-Host $stdout -ForegroundColor Gray
            if ($stderr) {
                Write-Host "Doxygen stderr:" -ForegroundColor Yellow
                Write-Host $stderr -ForegroundColor Gray
            }
            
            if ($exitCode -ne 0) {
                Write-Host "Doxygen failed with exit code $exitCode" -ForegroundColor Red
            } else {
                Write-Host "Doxygen completed successfully" -ForegroundColor Green
            }
            
            # Check if documentation already exists in the main repository
            $mainRepoPath = "/media/51drepos/$repo"
            $possibleMainOutputDirs = @(
                (Join-Path $mainRepoPath "4.4"),
                (Join-Path $mainRepoPath "4.5")
            )
            
            $sourceDir = $null
            foreach ($dir in $possibleMainOutputDirs) {
                if (Test-Path $dir) {
                    $htmlFiles = Get-ChildItem -Path $dir -Filter "*.html" -Recurse
                    if ($htmlFiles.Count -gt 5) {  # Main repos have many example files
                        $sourceDir = $dir
                        Write-Host "Found existing documentation in main repo: $sourceDir" -ForegroundColor Green
                        break
                    }
                }
            }
            
            # If not found in main repo, look in the temp directory  
            if (-not $sourceDir) {
                $possibleOutputDirs = @(
                    (Join-Path $repoPath "4.4"),
                    (Join-Path $repoPath "4.5"), 
                    (Join-Path (Split-Path $doxyfile -Parent) "html"),
                    (Join-Path $repoPath "html"),
                    (Join-Path $repoPath "docs/html")
                )
                
                foreach ($dir in $possibleOutputDirs) {
                    if (Test-Path $dir) {
                        $htmlFiles = Get-ChildItem -Path $dir -Filter "*.html" -Recurse
                        if ($htmlFiles.Count -gt 0) {
                            $sourceDir = $dir
                            Write-Host "Found generated documentation in temp repo: $sourceDir" -ForegroundColor Green
                            break
                        }
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


# Clean up temporary directory
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Documentation generation complete!" -ForegroundColor Green
Write-Host "Output directory: $OutputDir/" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green