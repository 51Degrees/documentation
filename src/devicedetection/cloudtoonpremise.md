@page DeviceDetection_CloudToOnPremise Migrating from Cloud to On-Premise

# Migrating from Cloud to On-Premise Device Detection

This guide walks you through migrating from 51Degrees Cloud Device Detection to On-Premise deployment. You'll learn when to migrate, how to update your configuration, and what changes to expect.

## When to Consider On-Premise

On-premise deployment works better when you need:

- **Faster response times** - Sub-microsecond detection with in-process deployment
- **Data privacy** - All processing happens within your infrastructure  
- **High-volume processing** - Handle millions of detections without API limits
- **Offline capability** - No internet connection required
- **Predictable costs** - Fixed licensing instead of per-request pricing

## Migration Steps Overview

1. Get an on-premise license and data file
2. Update package dependencies (if needed)
3. Change pipeline configuration 
4. Modify code for file-based detection
5. Set up data file updates
6. Test and optimize performance

## Step 1: Get License and Data File

**For testing:**
- Download the free Lite data file from [GitHub](https://github.com/51degrees/device-detection-data)
- No license key required, but limited device properties

**For production:**
- [Contact 51Degrees](https://51degrees.com/contact-us) to purchase an Enterprise license
- Includes full data file with all device properties
- Automatic data file updates included

## Step 2: Update Dependencies

Most 51Degrees packages already include both cloud and on-premise capabilities. You typically only need configuration changes.

**.NET**
```xml
<!-- Most users already have this -->
<PackageReference Include="FiftyOne.DeviceDetection" Version="4.x.x" />

<!-- Only if you had cloud-specific packages -->
<!-- Remove: FiftyOne.DeviceDetection.Cloud -->
<!-- Add: FiftyOne.DeviceDetection -->
```

**Java**
```xml
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>device-detection</artifactId>
    <version>4.x.x</version>
</dependency>
```

**Node.js**
```bash
npm install fiftyone.devicedetection
```

**Other Languages**
- **C/C++**: [device-detection-cxx](https://github.com/51degrees/device-detection-cxx)
- **Go**: [device-detection-go](https://github.com/51degrees/device-detection-go)  
- **PHP**: [device-detection-php-onpremise](https://github.com/51degrees/device-detection-php-onpremise)
- **Python**: `pip install fiftyone-devicedetection-onpremise`

## Step 3: Update Configuration

Replace your cloud configuration with file-based settings.

**Before (Cloud):**
```json
{
  "Elements": [
    {
      "elementKey": "device",
      "elementParameters": {
        "cloudEndpoint": "https://cloud.51degrees.com/api/v4",
        "resourceKey": "YOUR_RESOURCE_KEY"
      }
    }
  ]
}
```

**After (On-Premise):**
```json
{
  "Elements": [
    {
      "elementKey": "device", 
      "elementParameters": {
        "dataFilePath": "/path/to/51Degrees-LiteV4.1.hash",
        "performanceProfile": "MaxPerformance",
        "licenseKey": "YOUR_LICENSE_KEY",
        "autoUpdate": true,
        "updateOnStart": true,
        "fileSystemWatcher": true
      }
    }
  ]
}
```

## Step 4: Update Code

The Pipeline API keeps most code unchanged. Main differences:

**Pipeline Creation**

Before:
```csharp
var pipeline = new DeviceDetectionPipelineBuilder()
    .UseCloud(resourceKey)
    .Build();
```

After:
```csharp
var pipeline = new DeviceDetectionPipelineBuilder()
    .UseOnPremise(dataFilePath, licenseKey)
    .SetAutoUpdate(true)
    .SetPerformanceProfile(PerformanceProfiles.MaxPerformance)
    .Build();
```

**Error Handling**
- Handle file system errors instead of network errors
- Check data file permissions and disk space
- Monitor data file update failures

**Property Access**
- All properties are available locally (no cloud restrictions)
- No rate limiting on property requests
- Consistent response times regardless of property count

For complete examples:
- [On-Premise Console Examples](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise)
- [On-Premise Web Examples](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise)

## Step 5: Set Up Data File Updates

On-premise deployments need regular data file updates to detect new devices.

**Automatic Updates (Recommended)**

Configure the pipeline to handle updates:
- [Update on Startup](@ref DeviceDetection_Examples_DataFileUpdates_UpdateOnStartup_OnPremiseHash)
- [File System Watcher](@ref DeviceDetection_Examples_DataFileUpdates_FileSystemWatcher_OnPremiseHash)  
- [Polling Interval](@ref DeviceDetection_Examples_DataFileUpdates_PollingInterval_OnPremiseHash)

**Manual Updates**

Download new data files from the [51Degrees Distributor](https://51degrees.com/developers/distributor) using your license key.

## Step 6: Optimize Performance

**Choose Performance Profile**

- **MaxPerformance** - Fastest detection, uses more memory (recommended)
- **HighPerformance** - Good balance of speed and memory
- **LowMemory** - Slowest but minimal memory usage
- **Balanced** - Default middle ground

**Deployment Options**

- **In-Process** - Fastest option, detection in your application
- **Out-of-Process** - Separate process for isolation
- **Separate Server** - Centralized detection service

See [Performance Examples](@ref DeviceDetection_Examples_Performance_OnPremiseHash) for benchmarking.

## Testing Your Migration

1. **Compare Results** - Verify detection matches cloud results for test cases
2. **Load Testing** - Confirm performance under expected traffic
3. **Update Testing** - Ensure data file updates work without disruption
4. **Failover Testing** - Test what happens if data file becomes unavailable

## Common Migration Patterns

**Web Applications**
- Use [web integration examples](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise)
- Configure automatic request processing
- Add client-side evidence for better accuracy

**Batch Processing**
- Use [offline processing](@ref DeviceDetection_Examples_OfflineProcessing_OnPremiseHash)
- Process large User-Agent lists efficiently
- Use multi-threading for maximum throughput

**Microservices**
- Deploy as sidecar container
- Share data file via volume mount
- Use environment variables for configuration

## Planning Your Rollback

Keep cloud access during migration:

1. Maintain your cloud Resource Key
2. Use feature flags to switch between cloud and on-premise
3. Run both implementations in parallel initially
4. Gradually shift traffic to on-premise

## Troubleshooting

**Data file not found**
- Check file path is absolute and correct
- Verify file permissions allow read access
- Confirm data file downloaded successfully

**License key issues**
- Ensure license is for on-premise (not cloud)
- Check license hasn't expired
- Verify product tier matches your data file

**Poor performance**
- Confirm you're using MaxPerformance profile
- Check you're running in-process (not separate service)
- Review [performance examples](@ref DeviceDetection_Examples_Performance_OnPremiseHash)

**Memory usage too high**
- Switch to HighPerformance or LowMemory profile
- Consider out-of-process deployment
- Monitor memory usage patterns

## Next Steps

1. Review [on-premise examples](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise)
2. Set up [automatic data file updates](@ref DeviceDetection_Examples_DataFileUpdates_Index)
3. Enable [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) for better accuracy
4. Monitor [match metrics](@ref DeviceDetection_Examples_MatchMetrics_OnPremiseHash) for quality

## 💬 Get Help

- Enterprise support: [support@51degrees.com](mailto:support@51degrees.com)  
- Technical documentation: [On-Premise Guide](@ref DeviceDetection_Quickstart)
- Community support: [GitHub Issues](https://github.com/51Degrees)