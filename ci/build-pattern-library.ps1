$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$patternLibrary = "$PSScriptRoot/../pattern-library"

Push-Location $patternLibrary
try {
    npm install
    npx gulp sass-change
} finally {
    Pop-Location
}

Get-ChildItem $patternLibrary/source/css
Move-Item -Force $patternLibrary/source/css/docs-*.css $PSScriptRoot/../docs/
