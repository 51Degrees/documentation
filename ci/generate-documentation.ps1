$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

Set-StrictMode -Version 3.0
Set-Location "$PSScriptRoot/.."

Write-Host "::group::Installing native dependencies"
sudo apt-get install -y graphviz flex bison
Write-Host "::endgroup::"

Write-Host "::group::Fetching Doxygen"
Invoke-WebRequest 'https://github.com/51Degrees/tools/raw/refs/heads/main/DoxyGen/doxygen-linux.zip' -OutFile 'doxygen.zip'
Expand-Archive 'doxygen.zip' -DestinationPath .
Remove-Item -Force 'doxygen.zip'
$doxygen = "$PWD/doxygen-linux"
chmod +x $doxygen
& $doxygen -v
Write-Host "::endgroup::"

# This has to be done before building docs since docs depend on some of these sources
Write-Host "::group::Cloning API docs"
# We don't care about LFS files
$env:GIT_LFS_SKIP_SMUDGE = 1
# use PR target branch if we're running in a PR, or the current CI branch, or main
$ref = $env:GITHUB_BASE_REF ? $env:GITHUB_BASE_REF : $env:GITHUB_REF_NAME ? $env:GITHUB_REF_NAME : 'main'
$repoMap = & $PSScriptRoot/apis.ps1
# repos have to be cloned here since they expect documentation repo to be two levels above them
$apis = New-Item -Force -ItemType Directory "apis"
# some repos want documentation at the same level as them, in addition(!) to two levels above
New-Item -ItemType SymbolicLink -Force -Target $PWD -Path $apis/documentation | Out-Null
foreach ($_ in $repoMap.GetEnumerator()) {
    $repo, $examples = $_.Key, $_.Value
    git clone -b $ref --depth=1 --recurse-submodules --shallow-submodules "https://github.com/$env:GITHUB_REPOSITORY_OWNER/$repo.git" "$apis/$repo"
    if ($examples) {
        # clone examples inside their main repo
        git clone -b $ref --depth=1 "https://github.com/$env:GITHUB_REPOSITORY_OWNER/$examples.git" "$apis/$repo/$examples"
    }
}
Write-Host "::endgroup::"

Write-Host "::group::Generating docs"
Push-Location "docs"
try { & $doxygen } finally { Pop-Location }
$version = (Get-ChildItem -Directory -Filter '4.*')[0].Name
Write-Host "::endgroup::"

Write-Host "Generating API docs"
foreach ($_ in $repoMap.GetEnumerator()) {
    $repo, $examples = $_.Key, $_.Value
    Write-Host "::group::Generating $repo docs$($examples ? " with examples ($examples)" : $null)"
    Push-Location "$apis/$repo/docs"
    try { & $doxygen } finally { Pop-Location }
    $dest = New-Item -Force -ItemType Directory "$version/apis/$repo"
    Move-Item $apis/$repo/$version/* $dest
    Write-Host "::endgroup::"
}

Write-Host "::group::Checking out gh-pages"
git fetch --force --depth 2 origin gh-pages:gh-pages
git worktree add gh-pages # check out gh-pages as a worktree
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue gh-pages/$version
Move-Item $version gh-pages/$version
Write-Host "::endgroup::"

if (!(Test-Path "gh-pages/.nojekyll")) {
    '' > "gh-pages/.nojekyll"
}
