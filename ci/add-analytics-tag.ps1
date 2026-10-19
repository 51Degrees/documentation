<#
.SYNOPSIS
    Makes every page under -Path load the website's analytics page script
    exactly as -Header writes it.

.DESCRIPTION
    Pages generated with docs/header.html already carry the tag. The rest
    are pages DoxyGen writes without that header, such as
    doxygen_crawl.html and API sets whose Doxyfile keeps DoxyGen's default
    header, and pages the build no longer regenerates, such as archived
    versions.

    A page with no tag in its head gets the header's tag before </head>. A
    page whose tag differs from the header's gets the header's, so a change
    to the header reaches every page. A page that already matches is left
    as it is, and a file with no </head> is skipped.

.PARAMETER Path
    Root directory to walk recursively for *.html.

.PARAMETER Header
    The DoxyGen header that carries the tag.
#>
param(
    [Parameter(Mandatory)][string]$Path,
    [string]$Header = "$PSScriptRoot/../docs/header.html"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$tagRe = [regex]'<script\b[^>]*\bdata-fiftyone-analytics\b[^>]*>\s*</script>'
$tag = $tagRe.Match((Get-Content -Raw -LiteralPath $Header)).Value
if (-not $tag) {
    throw "add-analytics-tag.ps1: $Header has no analytics script tag"
}

$pages = 0
$changed = 0
foreach ($f in Get-ChildItem -Recurse -File -Filter "*.html" -LiteralPath $Path) {
    $content = Get-Content -Raw -LiteralPath $f.FullName
    if (-not $content) { continue }
    $end = $content.IndexOf('</head>', [StringComparison]::OrdinalIgnoreCase)
    if ($end -lt 0) { continue }
    $pages++
    $head = $content.Substring(0, $end)
    $found = $tagRe.Match($head)
    if ($found.Success) {
        if ($found.Value -ceq $tag) { continue }
        $head = $head.Remove($found.Index, $found.Length).Insert($found.Index, $tag)
    } else {
        $newline = $content.Contains("`r`n") ? "`r`n" : "`n"
        $head += "$tag$newline"
    }
    Set-Content -NoNewline -LiteralPath $f.FullName -Value ($head + $content.Substring($end))
    $changed++
}

Write-Host "$pages pages load the analytics page script, $changed of them changed by this step."
