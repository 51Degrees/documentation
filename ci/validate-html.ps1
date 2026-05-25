# Ignore Spelling: ci

<#
.SYNOPSIS
    Walks the generated HTML under -Path and warns about content-quality
    issues. Companion to the Website-side ContentValidator
    (postbuild/ContentValidator.cs in 51Degrees/Website), filed against
    51Degrees/documentation issue #151.

.DESCRIPTION
    Currently scans for one Semrush-rule-117 case: an <img> element with
    no alt attribute at all. An explicit alt="" is the WCAG-correct
    marking for a purely decorative image (screen readers skip it), so we
    flag only the absent-attribute form, never the empty-value form.
    Imgs with no src are also skipped: those are lazy-loaded placeholders
    or template stubs whose real img is populated later.

    Logged as warnings by default; pass -FailOnFinding to gate the build
    on a non-zero count. Default-warn matches the Website-side behaviour
    so we can watch the trend on a real build before adding teeth.

.PARAMETER Path
    Root directory to walk recursively for *.html.

.PARAMETER MaxIssuesLogged
    Cap on individual issue lines emitted, so a regression on a large
    page set doesn't flood the build log. Defaults to 200.

.PARAMETER FailOnFinding
    When $true, exits non-zero if any issues are found. Default $false.
#>
param(
    [Parameter(Mandatory)][string]$Path,
    [int]$MaxIssuesLogged = 200,
    [switch]$FailOnFinding
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    throw "validate-html.ps1: -Path '$Path' is not a directory"
}

$root = (Resolve-Path -LiteralPath $Path).Path
$files = Get-ChildItem -Recurse -File -Filter "*.html" -LiteralPath $root
$pagesScanned = 0
$issues = [System.Collections.Generic.List[string]]::new()

# Doxygen's HTML never spans an <img> tag across multiple lines, so a
# single-line regex is sufficient. The Website-side validator uses
# HtmlAgilityPack for the same job; ps1 stays leaner without it.
$imgRe = [regex]'<img\b[^>]*?>'

foreach ($f in $files) {
    $pagesScanned++
    # GetRelativePath normalises across short (DOS 8.3) vs. long path
    # spellings, which Substring on FullName cannot.
    $rel = [System.IO.Path]::GetRelativePath($root, $f.FullName) `
        -replace '\\','/'
    $content = Get-Content -Raw -LiteralPath $f.FullName
    foreach ($m in $imgRe.Matches($content)) {
        $tag = $m.Value
        # Has an alt attribute (even alt="") - the WCAG-correct form, not
        # a finding. Only the absent-attribute case fires.
        if ($tag -match '\balt\s*=') { continue }
        # No src either - lazy-loaded placeholder or template stub, skip.
        if ($tag -notmatch '\bsrc\s*=') { continue }
        $issues.Add("IMG-ALT /$rel : $tag")
    }
}

Write-Host ("HtmlValidator: scanned {0} pages, {1} content issues found" -f `
    $pagesScanned, $issues.Count)

$logged = 0
foreach ($issue in $issues) {
    if ($logged -ge $MaxIssuesLogged) { break }
    Write-Warning "HtmlValidator: $issue"
    $logged++
}
if ($issues.Count -gt $MaxIssuesLogged) {
    Write-Warning ("HtmlValidator: ...and {0} more (suppressed; raise " +
        "-MaxIssuesLogged to see all)" -f ($issues.Count - $MaxIssuesLogged))
}

if ($FailOnFinding.IsPresent -and $issues.Count -gt 0) {
    throw "HtmlValidator: $($issues.Count) findings, build gated by -FailOnFinding."
}
