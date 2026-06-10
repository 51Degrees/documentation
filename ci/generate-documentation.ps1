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
# The hreflang="en-US" alternate is emitted only on the unversioned
# mirror, never on the versioned source. The versioned URL canonicals
# at a different URL (the unversioned one), so emitting a hreflang
# anchor at that different URL from the versioned page is the cross-
# URL mismatch Semrush flags as a hreflang conflict (rule 24) or an
# incorrect hreflang link (rule 25). The mirror is self-canonical, so
# it carries the locale signal cleanly.
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
# Canonical documentation home. URLs below are emitted absolute against
# this host rather than root-relative. This loop is the single place the
# documentation HTML is normalised for the public site: the 51degrees.com
# reverse proxy used to rewrite every page at request time (add lang, swap
# the logo, absolutise canonical/hreflang, retarget the home link, fix
# member-list titles). Doing it once here at build time removes that per-
# request work and covers both these docs and every cloned API-repo
# doxygen build under <version>/apis/* in one pass. A preview / gh-pages
# build therefore carries production canonicals, which is intended: those
# hosts must not be indexed as the canonical, and the website no longer
# promotes hrefs per environment.
$site = "https://51degrees.com"
$srcRoot = (Resolve-Path "gh-pages/$version").Path
$baseTag = "<base href=`"/documentation/$version/`">"
$mirrored = [System.Collections.Generic.List[string]]::new()
$canonicalsAdded = 0
$hreflangsAdded = 0
$normalised = 0
Get-ChildItem -Recurse -File -Filter "*.html" -Path "gh-pages/$version" | ForEach-Object {
    $rel = $_.FullName.Substring($srcRoot.Length + 1) -replace '\\', '/'
    $dest = Join-Path "gh-pages" $rel
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    $content = Get-Content $_.FullName -Raw
    $before = $content

    # --- HTML normalisation (formerly performed by the website proxy) ---

    # Document language: doxygen omits lang on <html>; add it once.
    $content = $content -replace '(<html\b)(?![^>]*\blang=)', '$1 lang="en"'

    # Brand logo: doxygen ships the docs logo, the site shows the shared
    # brand logo whose request also serves as the analytics pixel when
    # served from 51degrees.com. Absolute so it resolves on any host.
    $content = $content -replace 'logo-51Degrees-Docs\.png', "$site/img/logo.png"

    # Home link: doxygen points the logo / "Main Page" link at index.html
    # (the docs index); send it to the site home instead.
    $content = $content -replace 'href="index\.html"', "href=`"$site/`""

    # Member-list titles: doxygen titles these pages "<Class> Member List";
    # use the page's own H2 title (g-docs__page-title) when present.
    $titleMatch = [regex]::Match($content, '<title>([^<]*Member List)</title>')
    if ($titleMatch.Success) {
        $h2 = [regex]::Match($content, '<h2[^>]*class="[^"]*g-docs__page-title[^"]*"[^>]*>(.*?)</h2>')
        if ($h2.Success) {
            $pageTitle = ($h2.Groups[1].Value -replace '<[^>]+>', '').Trim()
            if ($pageTitle) {
                $fixed = $titleMatch.Groups[1].Value -replace 'Member List', $pageTitle
                $content = $content.Replace($titleMatch.Value, "<title>$fixed</title>")
            }
        }
    }

    # Absolute canonical pointing at the unversioned URL on the canonical
    # documentation host. Both the versioned source and the unversioned
    # mirror canonicalise here so search engines consolidate equity on one
    # URL.
    $canonicalTag = "<link rel=`"canonical`" href=`"$site/documentation/$rel`">"

    # hreflang alternate sharing the canonical's href. en-US matches the
    # single-locale site. Emitted only on the self-canonical mirror (see
    # below) to avoid the cross-URL hreflang Semrush flags (rules 24/25).
    $hreflangTag = "<link rel=`"alternate`" hreflang=`"en-US`" href=`"$site/documentation/$rel`" />"

    # Add canonical to the versioned source in place when it doesn't
    # already have one (doxygen-generated pages don't ship one).
    if ($content -notmatch '<link\s+rel=["'']?canonical') {
        $content = $content -replace '(<head[^>]*>)', "`$1`n  $canonicalTag"
        $canonicalsAdded++
    }

    # Persist the normalised + canonicalised versioned source when it
    # changed. The guards above keep this idempotent across re-runs.
    if ($content -ne $before) {
        Set-Content -Path $_.FullName -Value $content -NoNewline
        $normalised++
    }

    # Mirror copy under the unversioned root. The mirror adds <base> so
    # relative refs into versioned assets still resolve. The base stays
    # root-relative on purpose so assets resolve on whichever host serves
    # the page.
    if ($content -notmatch '<base\s') {
        $content = $content -replace '(<head[^>]*>)', "`$1`n  $baseTag"
    }

    # Inject the hreflang alternate into the mirror only, and only when the
    # existing canonical on this page points at the mirror's own URL. Two
    # conditions have to hold:
    #   * The page does not already carry an hreflang (idempotent on re-runs
    #     and safe against a future template change that ships one).
    #   * The canonical href equals the mirror's URL. Pages whose canonical
    #     points elsewhere -- e.g. api-repo doxygen pages whose own template
    #     sets a different consolidation target -- are not self-canonical and
    #     so must not declare a hreflang anchor at a different URL.
    $mirrorUrl = "$site/documentation/$rel"
    $existingCanonical = $null
    $canonicalMatch = [regex]::Match($content, '<link\s+rel="canonical"\s+href="([^"]+)"')
    if ($canonicalMatch.Success) {
        $existingCanonical = $canonicalMatch.Groups[1].Value
    }
    if ($existingCanonical -eq $mirrorUrl -and
        $content -notmatch '<link\s+rel=["'']?alternate["'']?\s+hreflang=') {
        $content = $content -replace '(<link\s+rel="canonical"\s+href="[^"]*">)', "`$1`n  $hreflangTag"
        $hreflangsAdded++
    }

    Set-Content -Path $dest -Value $content -NoNewline
    $mirrored.Add($rel)
}
Set-Content -Path $manifestPath -Value ($mirrored -join "`n")
Write-Host "Mirrored $($mirrored.Count) HTML files, normalised $normalised, added canonical to $canonicalsAdded, hreflang to $hreflangsAdded."
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
Write-Host "::group::Validating generated HTML"
& "$PSScriptRoot/validate-html.ps1" -Path "gh-pages/$version" -FailOnFinding
Write-Host "::endgroup::"
