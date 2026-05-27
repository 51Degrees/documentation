#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Rebalance the heading hierarchy in every generated documentation
    HTML file so each page has exactly one <h1> (the page title) and
    every section heading is an <h2>.

.DESCRIPTION
    Out of the box Doxygen emits the page title at h2 with class
    `g-docs__page-title`, and every section heading at h1 with class
    `g-docs__section-heading`. That gives each page N+1 h1s and no
    h1 for the actual page title, which Semrush rule 104 ("Multiple
    H1 tags") flags. The post-PR #588 site audit flagged 130 pages,
    every one of them under /documentation/4.5/. See documentation
    issue #154 for the full investigation.

    This script promotes the page-title h2 to h1 and demotes each
    section-heading h1 to h2 by class. Class attributes (and any
    other attributes on the tag) are preserved so existing CSS and
    fragment links continue to work.

    The transform is idempotent: re-running on already-rebalanced
    HTML is a no-op because the class selectors no longer match
    the original tag names.

.PARAMETER Path
    Directory to walk recursively for *.html files. Mandatory.

.EXAMPLE
    pwsh ci/rebalance-doc-headings.ps1 -Path gh-pages/4.5
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

# Single-line heading regexes. Doxygen emits the page title and
# section headings with their inner text on one line, so we don't
# need balanced-tag matching here -- the closing tag follows on
# the same physical line.
#
# (?i)       case-insensitive
# (\b...)    the rest of the tag's attributes (class + id + ...)
# (?-i:...)  pin the inner text capture to whatever the source has
$pageTitlePattern = `
    '(?i)<h2(\b[^>]*?\bclass\s*=\s*"[^"]*?\bg-docs__page-title\b[^"]*?"[^>]*)>([^<]*)</h2>'
$pageTitleReplacement = '<h1$1>$2</h1>'

$sectionHeadingPattern = `
    '(?i)<h1(\b[^>]*?\bclass\s*=\s*"[^"]*?\bg-docs__section-heading\b[^"]*?"[^>]*)>([^<]*)</h1>'
$sectionHeadingReplacement = '<h2$1>$2</h2>'

if (-not (Test-Path $Path)) {
    throw "Path '$Path' does not exist."
}

$resolved = (Resolve-Path $Path).Path
$totalFiles = 0
$changedFiles = 0
$totalPageTitlePromotions = 0
$totalSectionHeadingDemotions = 0

foreach ($file in Get-ChildItem -Path $resolved -Recurse -File -Filter '*.html') {
    $totalFiles++
    $original = Get-Content $file.FullName -Raw

    # Count matches before/after for telemetry. Doing the count
    # separately from the replace lets us report exactly how many
    # tags we rewrote in each file.
    $promotions = [regex]::Matches($original, $pageTitlePattern).Count
    $demotions = [regex]::Matches($original, $sectionHeadingPattern).Count
    if ($promotions -eq 0 -and $demotions -eq 0) {
        continue
    }

    $rewritten = $original -replace `
        $pageTitlePattern, $pageTitleReplacement
    $rewritten = $rewritten -replace `
        $sectionHeadingPattern, $sectionHeadingReplacement

    if ($rewritten -ne $original) {
        Set-Content -Path $file.FullName -Value $rewritten -NoNewline
        $changedFiles++
        $totalPageTitlePromotions += $promotions
        $totalSectionHeadingDemotions += $demotions
    }
}

Write-Host (
    "rebalance-doc-headings: scanned $totalFiles files, " +
    "rewrote $changedFiles, " +
    "promoted $totalPageTitlePromotions page-title h2 -> h1, " +
    "demoted $totalSectionHeadingDemotions section-heading h1 -> h2."
)
