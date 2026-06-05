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

# Mirror the current version's HTML at the unversioned path so links
# like /documentation/_foo.html resolve directly without redirecting.
# Each mirror gets <base href="/documentation/<version>/"> so relative
# asset and nav refs still resolve into the versioned tree, and a
# canonical link pointing back at the unversioned form so search
# engines index that as the canonical URL.
#
# A .mirror-manifest at the gh-pages root records what we wrote so the
# next run (after a version bump or a Doxygen page rename) cleans up
# stale mirrors before recreating fresh ones.
Write-Host "::group::Mirroring current-version HTML to unversioned root"
$manifestPath = "gh-pages/.mirror-manifest"
if (Test-Path $manifestPath) {
    Get-Content $manifestPath | Where-Object { $_ } | ForEach-Object {
        Remove-Item -Force -ErrorAction SilentlyContinue (Join-Path "gh-pages" $_)
    }
}
$srcRoot = (Resolve-Path "gh-pages/$version").Path
$baseTag = "<base href=`"/documentation/$version/`">"
$mirrored = [System.Collections.Generic.List[string]]::new()
$canonicalsAdded = 0
Get-ChildItem -Recurse -File -Filter "*.html" -Path "gh-pages/$version" | ForEach-Object {
    $rel = $_.FullName.Substring($srcRoot.Length + 1) -replace '\\', '/'
    $dest = Join-Path "gh-pages" $rel
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    $content = Get-Content $_.FullName -Raw

    # Root-relative canonical pointing at the unversioned URL. Both the
    # versioned source and the unversioned mirror canonicalise here, so
    # search engines consolidate equity on /documentation/$rel and the
    # same rendered HTML is portable across any host (production,
    # staging, preview, localhost).
    $canonicalTag = "<link rel=`"canonical`" href=`"/documentation/$rel`">"

    # Add canonical to the versioned source in place when it doesn't
    # already have one (doxygen-generated pages don't ship one). The
    # site's reverse proxy used to inject this at request time but
    # pinned the rendered HTML to one host; doing it here once at
    # build time keeps the output portable. See
    # 51Degrees/Website#699 for the corresponding proxy-side change.
    if ($content -notmatch '<link\s+rel=["'']?canonical') {
        $content = $content -replace '(<head[^>]*>)', "`$1`n  $canonicalTag"
        Set-Content -Path $_.FullName -Value $content -NoNewline
        $canonicalsAdded++
    }

    # Mirror copy under the unversioned root. The mirror adds <base>
    # so relative refs into versioned assets still resolve, and we
    # ensure the canonical is present (carried over from the in-place
    # update above, or copied in here for the rare file that already
    # had a self-canonical).
    if ($content -notmatch '<base\s') {
        $content = $content -replace '(<head[^>]*>)', "`$1`n  $baseTag"
    }
    Set-Content -Path $dest -Value $content -NoNewline
    $mirrored.Add($rel)
}
Set-Content -Path $manifestPath -Value ($mirrored -join "`n")
Write-Host "Mirrored $($mirrored.Count) HTML files to gh-pages root, added canonical to $canonicalsAdded versioned files."
Write-Host "::endgroup::"

# Minify the Doxygen-emitted JS (jquery.js, navtree.js, dynsections.js,
# search51.js, examplegrabber.js, testedversionsgrabber.js, ...) and
# rewrite <script src="*.js"> in every generated page to load the
# *.min.js sibling. Mirrors the docs-main.css / docs-main.min.css
# convention already used for the stylesheet. Clears the Semrush rule
# 135 ("unminified JavaScript and CSS files") findings on every
# /documentation/* page on 51degrees.com.
Write-Host "::group::Minifying Doxygen-emitted JS"
Push-Location ci
try { npm ci --omit=dev=false --no-audit --no-fund } finally { Pop-Location }
node ci/minify-docs-assets.js gh-pages
Write-Host "::endgroup::"

# Scan the freshly generated HTML for content-quality regressions
# before it gets published. Companion to the Website-side
# ContentValidator (postbuild/ContentValidator.cs); see
# 51Degrees/documentation issue #151 for context. The 2026-05-25
# scheduled build ran clean ("scanned 5150 pages, 0 content issues
# found"), so the baseline is genuinely zero -- run with
# -FailOnFinding from here on to break the build on any regression
# rather than waiting for someone to spot the warning in the log.
Write-Host "::group::Rebalancing heading hierarchy"
# Doxygen emits the page title at h2.g-docs__page-title and every
# section heading at h1.g-docs__section-heading, which Semrush
# rule 104 ("Multiple H1 tags") flags. Promote the page-title h2
# to h1 and demote each section-heading h1 to h2 before
# validation. Idempotent: a future doxygen-template fix that
# already emits the right hierarchy makes this a no-op rather
# than introducing a regression. See documentation issue #154.
& "$PSScriptRoot/rebalance-doc-headings.ps1" -Path "gh-pages/$version"
Write-Host "::endgroup::"

Write-Host "::group::Validating generated HTML"
& "$PSScriptRoot/validate-html.ps1" -Path "gh-pages/$version" -FailOnFinding
Write-Host "::endgroup::"
