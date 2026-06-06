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

    Three passes run in order:

    1. Promote the page-title h2 to h1 by class
       (`g-docs__page-title`).
    2. Demote each section-heading h1 to h2 by class
       (`g-docs__section-heading`).
    3. Demote every remaining body-level h1 to h2 (Doxygen also
       converts plain markdown `# Section Title` lines to <h1>
       with no recognisable class, e.g.
       `<h1><a class="anchor" id="..."></a> Title</h1>`).
       The page-title h1 produced by pass 1 is preserved because
       it carries `class="g-docs__page-title"`.

    Class attributes (and any other attributes on the tag) are
    preserved on every rewrite so existing CSS and fragment links
    continue to work.

    The transform is idempotent: re-running on already-rebalanced
    HTML is a no-op because the class selectors no longer match
    the original tag names and the only remaining <h1> is the
    page-title h1, which pass 3 skips.

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

# Catch-all opening-tag pattern for pass 3. Matches any <h1 ...>
# regardless of attributes (or lack of). The body-h1 sweep below
# inspects each match's attributes and skips the page-title h1
# produced by pass 1.
$bodyH1OpenPattern = '(?i)<h1(\b[^>]*)>'
$pageTitleClassPattern = `
    '(?i)class\s*=\s*(["''])[^"'']*\bg-docs__page-title\b[^"'']*\1'

$resolved = (Resolve-Path $Path).Path
$totalFiles = 0
$changedFiles = 0
$totalPageTitlePromotions = 0
$totalSectionHeadingDemotions = 0
$totalBodyH1Demotions = 0

foreach ($file in Get-ChildItem -Path $resolved -Recurse -File -Filter '*.html') {
    $totalFiles++
    $original = Get-Content $file.FullName -Raw

    # Count matches before/after for telemetry. Doing the count
    # separately from the replace lets us report exactly how many
    # tags we rewrote in each file.
    $promotions = [regex]::Matches($original, $pageTitlePattern).Count
    $demotions = [regex]::Matches($original, $sectionHeadingPattern).Count

    $rewritten = $original -replace `
        $pageTitlePattern, $pageTitleReplacement
    $rewritten = $rewritten -replace `
        $sectionHeadingPattern, $sectionHeadingReplacement

    # Pass 3: demote any remaining body <h1> that is NOT the
    # page-title h1 (which now carries `class="g-docs__page-title"`
    # after pass 1). Doxygen converts plain markdown `# Title`
    # lines to <h1> with no recognisable class, so the by-class
    # passes above miss them. Walk the matches in reverse so
    # earlier rewrites do not shift later indices, and rewrite
    # the closing </h1> before the opening <h1 so the opening
    # tag's stored Index stays valid.
    $bodyMatches = [regex]::Matches($rewritten, $bodyH1OpenPattern)
    $bodyDemotions = 0
    for ($i = $bodyMatches.Count - 1; $i -ge 0; $i--) {
        $m = $bodyMatches[$i]
        $attrs = $m.Groups[1].Value
        if ($attrs -match $pageTitleClassPattern) { continue }
        $closeAt = $rewritten.IndexOf(
            '</h1>', $m.Index + $m.Length,
            [System.StringComparison]::OrdinalIgnoreCase)
        if ($closeAt -lt 0) { continue }
        # Replace closing tag first so the opening-tag index stays
        # valid for the second Remove/Insert.
        $rewritten = $rewritten.Remove($closeAt, 5).Insert($closeAt, '</h2>')
        $rewritten = $rewritten.Remove($m.Index, $m.Length).Insert(
            $m.Index, '<h2' + $attrs + '>')
        $bodyDemotions++
    }

    if ($rewritten -ne $original) {
        Set-Content -Path $file.FullName -Value $rewritten -NoNewline
        $changedFiles++
        $totalPageTitlePromotions += $promotions
        $totalSectionHeadingDemotions += $demotions
        $totalBodyH1Demotions += $bodyDemotions
    }
}

Write-Host (
    "rebalance-doc-headings: scanned $totalFiles files, " +
    "rewrote $changedFiles, " +
    "promoted $totalPageTitlePromotions page-title h2 -> h1, " +
    "demoted $totalSectionHeadingDemotions section-heading h1 -> h2, " +
    "demoted $totalBodyH1Demotions body-level h1 -> h2."
)
