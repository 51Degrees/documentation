@page Info_Distributor Distributor

The 51Degrees Distributor service is a client-facing cloud-based service which is used by the 
API to request the latest data files. You can also manually download files via the front end on
our [website](https://51degrees.com/developers/downloads/enhanced-device-data), or by calling the 
Distributor web API directly using curl or similar.

The URL is `https://distributor.51degrees.com/api/v2/download`

## Parameters

Query string parameters are supplied as normal.
For example: `https://distributor.51degrees.com/api/v2/download?LicenseKeys=ABC&Type=27&Product=23`

| Parameter      | Description      | Possible values     |
|---|---|---|
| LicenseKeys    | Pipe-separated list of 51Degrees License Keys. You must have a valid License Key for the data file that you are trying to download. | N/A  |
| Type           | The type of data file to download.  | <ul><li>12 = Enterprise V3.1 Pattern</li><li>16 = Enterprise V3.2 Pattern</li><li>21 = CSV</li><li>27 = Hash V4.1</li></ul>  |
| Product        | The 51Degrees 'product' that the data file is part of. | <ul><li>4 = V3 Enterprise</li><li>23 = V4 TAC</li></ul> |
| Download       | Legacy - Has no effect | True/False          |

## HTTP headers

### Response headers 

The server will respond with a `Content-MD5` header. This contains the MD5 hash of the data file content.
It can be used to verify the download by hashing the content and comparing the result with the value in this header. For an example see https://docs.developer.amazonservices.com/en_DE/dev_guide/DG_MD5.html 

The server will also respond with a `Last-Modified` header. This contains the publish date of the data file that is being downloaded.
This value should be used to populate the `If-Modified-Since` header on the next request (see request headers below).

If returning a 429 status (see response codes below), the server will specify an `Retry-After` header. This is the minimum number of seconds to wait before the distributor will serve requests for this License Key.

### Request headers

The sender may supply an [`If-Modified-Since`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Modified-Since) header. If present, the Distributor will check the date supplied in the header against the publish date for the latest data file.
If the data file is older or the same, the server will return HTTP status code 304.
If the data file is newer, it will be returned, along with HTTP 200.

## Response codes

| Response code     | Meaning + Notes      |
|---|---|
| 200               | Success. The content of the response message will include the requested data file. |
| 300               | Multiple choices. There are multiple possible options for this License Key. You must specify the 'Product' parameter. |
| 304               | Not modified. The latest data file's publish date is not newer than the date supplied by the `If-Modified-Since` header (see request headers above). |
| 400               | Bad request. Check the URL is correct and that the required parameters are supplied. Also returned if the License Key is invalid |
| 403               | Forbidden. The supplied License Key has been revoked. Contact support@51degrees.com for assistance. |
| 404               | Not found. Usually indicates that a License Key has been supplied without a 'Product', and the Distributor has been unable to automatically determine which product you want. May also occur due to the supplied product and type being an invalid combination. | 
| 429               | Too many requests. Has a couple of causes <ul><li>You are over the threshold of requests per minute for this License Key. The server will specify a `Retry-After` header. Also see the 'Recommendations for large clusters' section at the bottom of the [data updates feature page](@ref Features_AutomaticDatafileUpdates) for advice.</li><li>`Unable to update the data file successfully due to another process using the file.` This is an internal failure due to the way Distributor currently works. It should be resolved if you try again in a few minutes.</li></ul> |
| 500               | Internal server error. Some unexpected problem has occurred. Please try again later and contact support@51degrees.com if this continues |



