$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$patternLibrary = "$PSScriptRoot/../pattern-library"

Push-Location $patternLibrary
try {
    npm install
    # Compile the SCSS design system to CSS with Vite (gulp retired).
    npm run build:css
} finally {
    Pop-Location
}

Get-ChildItem $patternLibrary/source/css
Move-Item -Force $patternLibrary/source/css/docs-*.css $PSScriptRoot/../docs/
