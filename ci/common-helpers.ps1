# Common helper functions for documentation generation scripts

# Helper function to run Doxygen with optional verbose output
function Invoke-Doxygen {
    param(
        [string]$DoxygenPath,
        [switch]$ShowDoxygenOutput = $false
    )
    
    if ($ShowDoxygenOutput) {
        & $DoxygenPath | Out-Host
    } else {
        & $DoxygenPath 2>&1 | Out-Null
    }
    
    return $LASTEXITCODE
}