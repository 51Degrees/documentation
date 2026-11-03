# Maps each API, by the name its documentation is published under, to its
# examples repository (if any). An API built from a folder of a monorepo names
# the repository and the folder holding its Doxyfile instead.
[ordered]@{
    # Pipeline
    "pipeline-dotnet" = $null
    "pipeline-java" = $null
    "pipeline-node" = @{ Repo = "51degrees-node"; Docs = "pipeline/docs" }
    "pipeline-php" = @{ Repo = "51degrees-php"; Docs = "docs" }
    "pipeline-python" = @{ Repo = "51degrees-python"; Docs = "pipeline/docs" }

    # Device Detection
    "device-detection-cxx" = @{ Repo = "51degrees-cxx"; Docs = "docs/dd" }
    "device-detection-dotnet" = "device-detection-dotnet-examples"
    "device-detection-java" = "device-detection-java-examples"
    "device-detection-nginx" = $null
    "device-detection-node" = @{ Repo = "51degrees-node"; Docs = "device-detection/docs" }
    "device-detection-php" = @{ Repo = "51degrees-php"; Docs = "device-detection/cloud/docs" }
    "device-detection-php-onpremise" = @{ Repo = "51degrees-php"; Docs = "device-detection/onpremise/docs" }
    "device-detection-python" = @{ Repo = "51degrees-python"; Docs = "device-detection/docs" }

    # IP Intelligence
    "ip-intelligence-cxx" = @{ Repo = "51degrees-cxx"; Docs = "docs/ipi" }
    "ip-intelligence-dotnet" = "ip-intelligence-dotnet-examples"
    "ip-intelligence-go" = $null
    "ip-intelligence-java" = "ip-intelligence-java-examples"
    "ip-intelligence-node" = @{ Repo = "51degrees-node"; Docs = "ip-intelligence/docs" }

    # Rust (Device Detection + IP Intelligence). The runnable examples live in
    # the rust repo's own examples/ workspace, so there is no separate examples
    # repository to clone.
    "rust" = $null

    # Location
    "location-dotnet" = $null
    "location-java" = $null
    "location-node" = @{ Repo = "51degrees-node"; Docs = "location/docs" }
    "location-php" = @{ Repo = "51degrees-php"; Docs = "location/docs" }
    "location-python" = @{ Repo = "51degrees-python"; Docs = "location/docs" }
}
