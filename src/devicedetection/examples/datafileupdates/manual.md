@page DeviceDetection_Examples_DataFileUpdates_Manual Manual

# Introduction

New device detection data files are released daily by 51Degrees. Where possible, we recommend using the [automatic update](@ref PipelineApi_Features_AutomaticDatafileUpdates) feature to ensure you are using the latest data file. However, this feature is not available for all languages, and is not practical in all environments. 

This example demonstrates how to prompt the Device Detection @aspectengine to refresh it's internal data structures from the data file after it has been updated on disk.

Note that, in all languages, the same function can also be used to update the Device Detection @aspectengine from a data file that is held in memory.

@startsnippets
@grabexample{device-detection-php-onpremise,onpremise_2manual_data_update_8php,PHP}
@grabbedexample
@endsnippets
