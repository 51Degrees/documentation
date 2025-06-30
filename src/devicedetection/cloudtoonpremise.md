@page DeviceDetection_CloudToOnPremise Migrating from Cloud to On-Premise

# Migrating from Cloud to On-Premise Device Detection

This guide helps you transition from 51Degrees Cloud Device Detection to On-Premise deployment, enabling sub-microsecond detection times and complete data privacy.

## Why Migrate to On-Premise? <a href="#why-migrate">#</a> @anchor why-migrate

Consider migrating when you need:

- **⚡ Ultra-low latency** - Sub-microsecond detection time with in-process deployment
- **🔒 Complete privacy** - All processing stays within your infrastructure
- **📈 High volume processing** - Over 1 million detections per second per CPU core
- **🌐 Offline capability** - No internet dependency for detection
- **💰 Cost efficiency at scale** - Fixed licensing vs pay-per-request

## Migration Overview <a href="#migration-overview">#</a> @anchor migration-overview

The migration process involves:

1. Obtaining an On-Premise License Key and @datafile
2. Updating your dependencies
3. Modifying pipeline configuration
4. Implementing data file updates
5. Testing and optimization

## Step 1: Obtain License Key and Data File <a href="#step1-license">#</a> @anchor step1-license

1. **Choose your data file**:
   - **Lite** - Free data file with limited properties (no License Key required)
   - **Enterprise** - Full data file with all properties (requires License Key)
2. **For Enterprise users**: [Contact us](https://51degrees.com/contact-us) to purchase a License Key

## Step 2: Update Dependencies <a href="#step2-dependencies">#</a> @anchor step2-dependencies

Most packages already include both cloud and on-premise capabilities - only configuration changes are needed:

<b>.NET</b>

```xml
<!-- FiftyOne.DeviceDetection includes both cloud and on-premise -->
<PackageReference Include="FiftyOne.DeviceDetection" Version="4.x.x" />

<!-- Only replace if you were using cloud-specific packages -->
<!-- Remove: FiftyOne.DeviceDetection.Cloud -->
<!-- Add: FiftyOne.DeviceDetection -->
```

**Java**

```xml
<!-- Maven - device-detection includes both cloud and on-premise -->
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>device-detection</artifactId>
    <version>4.x.x</version>
</dependency>
```

**Node.js**

```bash
# Package includes both cloud and on-premise capabilities
npm install fiftyone.devicedetection
```

**Other Languages**

- **C/C++**: Clone [device-detection-cxx](https://github.com/51degrees/device-detection-cxx)
- **Go**: Clone [device-detection-go](https://github.com/51degrees/device-detection-go)
- **PHP**: Clone [device-detection-php-onpremise](https://github.com/51degrees/device-detection-php-onpremise)
- **Python**: Install `fiftyone-devicedetection-onpremise`

## Step 3: Update Pipeline Configuration <a href="#step3-configuration">#</a> @anchor step3-configuration

**From Cloud Configuration:**

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

**To On-Premise Configuration:**

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

## Step 4: Code Changes <a href="#step4-code-changes">#</a> @anchor step4-code-changes

**Minimal Code Changes Required**

The beauty of 51Degrees Pipeline API is that most code remains unchanged. The primary differences are:

1. **Pipeline Creation** - Use file-based builder instead of cloud builder
2. **Error Handling** - Handle file-related errors instead of network errors
3. **Property Access** - All properties available locally (no cloud property restrictions)

**Example: Pipeline Creation**

**Cloud Version:**

```csharp
var pipeline = new DeviceDetectionPipelineBuilder()
    .UseCloud(resourceKey)
    .Build();
```

**On-Premise Version:**

```csharp
var pipeline = new DeviceDetectionPipelineBuilder()
    .UseOnPremise(dataFilePath, licenseKey)
    .SetAutoUpdate(true)
    .SetPerformanceProfile(PerformanceProfiles.MaxPerformance)
    .Build();
```

For complete examples, see:

- [On-Premise Console Examples](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise)
- [On-Premise Web Examples](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise)

## Step 5: Implement Data File Updates <a href="#step5-updates">#</a> @anchor step5-updates

On-premise deployments require periodic data file updates for latest device information:

**Automatic Updates (Recommended)**

Configure automatic updates in your pipeline:

- [Update on Startup](@ref DeviceDetection_Examples_DataFileUpdates_UpdateOnStartup_OnPremiseHash)
- [File System Watcher](@ref DeviceDetection_Examples_DataFileUpdates_FileSystemWatcher_OnPremiseHash)
- [Polling Interval](@ref DeviceDetection_Examples_DataFileUpdates_PollingInterval_OnPremiseHash)

**Manual Updates**

Download new data files from the [51Degrees Distributor](https://51degrees.com/developers/distributor) using your License Key.

## Step 6: Performance Optimization <a href="#step6-performance">#</a> @anchor step6-performance

**Performance Profiles**

We recommend **MaxPerformance** for optimal speed:

- **MaxPerformance** - Fastest detection, higher memory usage (recommended)
- **HighPerformance** - Balanced speed and memory
- **LowMemory** - Minimal memory footprint
- **Balanced** - Default balanced option

**Deployment Options**

- **In-Process** (Default) - Sub-microsecond latency
- **Out-of-Process** - Process isolation
- **Separate Server** - Centralized detection service

See [Performance Examples](@ref DeviceDetection_Examples_Performance_OnPremiseHash) for benchmarking.

## Step 7: Testing and Validation <a href="#step7-testing">#</a> @anchor step7-testing

1. **Compare Results** - Verify detection results match cloud version
2. **Performance Testing** - Confirm latency improvements
3. **Load Testing** - Validate throughput at expected volumes
4. **Update Testing** - Ensure data file updates work correctly

## Common Migration Scenarios <a href="#migration-scenarios">#</a> @anchor migration-scenarios

**Web Applications**

- Use [on-premise web integration](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise)
- Configure middleware for automatic request processing
- Enable client-side evidence for enhanced accuracy

**Batch Processing**

- Use [offline processing](@ref DeviceDetection_Examples_OfflineProcessing_OnPremiseHash)
- Process User-Agent lists efficiently
- Leverage multi-threading for maximum throughput

**Microservices**

- Deploy as sidecar container
- Share data file via volume mount
- Use environment variables for configuration

## Rollback Plan <a href="#rollback">#</a> @anchor rollback

Keep cloud configuration available during migration:

1. Maintain cloud Resource Key
2. Use feature flags to switch between cloud/on-premise
3. Monitor both implementations initially
4. Gradually migrate traffic to on-premise

## Troubleshooting <a href="#troubleshooting">#</a> @anchor troubleshooting

**Common Issues**

**Data file not found**

- Verify file path is absolute
- Check file permissions
- Ensure data file is downloaded

**License Key invalid**

- Confirm License Key is for on-premise use
- Check License expiration
- Verify product tier matches data file

**Performance not improved**

- Check performance profile setting
- Verify in-process deployment
- Review [performance examples](@ref DeviceDetection_Examples_Performance_OnPremiseHash)

## Next Steps <a href="#next-steps">#</a> @anchor next-steps

1. Review [on-premise examples](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise)
2. Implement [automatic updates](@ref DeviceDetection_Examples_DataFileUpdates_Index)
3. Enable [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) for enhanced accuracy
4. Monitor [match metrics](@ref DeviceDetection_Examples_MatchMetrics_OnPremiseHash) for quality assurance

## Need Help?

- 📧 Enterprise support: [support@51degrees.com](mailto:support@51degrees.com)
- 📚 Documentation: [On-Premise Integration Guide](@ref DeviceDetection_Quickstart)
- 💬 Community: [GitHub Discussions](https://github.com/51Degrees)
