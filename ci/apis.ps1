# Maps each API, by the name its documentation is published under, to its
# examples repository (if any). An API built from a folder of a monorepo names
# the repository and the folder holding its Doxyfile instead.
[ordered]@{
    # Pipeline
    "pipeline-dotnet" = $null
    "pipeline-java" = @{ Repo = "51degrees-java"; Docs = "pipeline/docs" }
    "pipeline-node" = @{ Repo = "51degrees-node"; Docs = "pipeline/docs" }
    "pipeline-python" = $null

    # Device Detection
    "device-detection-cxx" = @{ Repo = "51degrees-cxx"; Docs = "docs/dd" }
    "device-detection-dotnet" = "device-detection-dotnet-examples"
    "device-detection-java" = @{ Repo = "51degrees-java"; Docs = "device-detection/docs" }
    "device-detection-nginx" = $null
    "device-detection-node" = @{ Repo = "51degrees-node"; Docs = "device-detection/docs" }
    "device-detection-php" = $null
    "device-detection-php-onpremise" = $null
    "device-detection-python" = $null

    # IP Intelligence
    "ip-intelligence-cxx" = @{ Repo = "51degrees-cxx"; Docs = "docs/ipi" }
    "ip-intelligence-dotnet" = "ip-intelligence-dotnet-examples"
    "ip-intelligence-go" = $null
    "ip-intelligence-java" = @{ Repo = "51degrees-java"; Docs = "ip-intelligence/docs" }
    "ip-intelligence-node" = @{ Repo = "51degrees-node"; Docs = "ip-intelligence/docs" }

    # Rust (Device Detection + IP Intelligence). The runnable examples live in
    # the rust repo's own examples/ workspace, so there is no separate examples
    # repository to clone.
    "rust" = $null

    # Location
    "location-dotnet" = $null
    "location-java" = @{ Repo = "51degrees-java"; Docs = "location/docs" }
    "location-node" = @{ Repo = "51degrees-node"; Docs = "location/docs" }
    "location-php" = $null
    "location-python" = $null
}
