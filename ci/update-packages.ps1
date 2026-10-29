param (
    [Parameter(Mandatory=$true)]
    [string]$RepoName
)

# Folders holding a package.json. This runs from the common-ci checkout, whose
# node/update-packages.ps1 runs npm update --save in each one.
$packages = @("ci", "pattern-library")

./node/update-packages.ps1 -RepoName $RepoName -Packages $packages

exit $LASTEXITCODE
