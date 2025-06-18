@page Services_Distributor Distributor (On-Premise)

The 51Degrees Distributor service is a client-facing cloud-based service which is used by the 
API to request the latest data files. You can also manually download files via the front end on
our [website](https://51degrees.com/developers/downloads/enhanced-device-data), or by calling the 
Distributor web API directly using curl or similar.

The URL is `%https://distributor.51degrees.com/api/v2/download`

## Parameters

Query string parameters are supplied as normal.
For example: `%https://distributor.51degrees.com/api/v2/download?LicenseKeys=ABC&Type=27&Product=23`
If you're unsure what 'product' or 'type' values to use, check the download page on the 
[website](https://51degrees.com/developers/downloads/enhanced-device-data) and copy the link
for the file you need from there.


| Parameter      | Description      | Possible values     |
|---|---|---|
| LicenseKeys    | Pipe-separated list of 51Degrees License Keys. You must have a valid License Key for the data file that you are trying to download. | N/A  |
| Type           | The type of data file to download. Accepts either the string or id from the list of values. | <ul><li>12 or `BinaryV3` = V3.1 Pattern</li><li>13 or `BinaryV3Uncompressed` = V3.1 Pattern uncompressed</li><li>16 or `BinaryV32` = V3.2 Pattern</li><li>17 or `BinaryV32Uncompressed` = V3.2 Pattern uncompressed</li><li>18 or `BinaryV32UAT` = V3.2 Pattern file with a very limited set of data. Designed to support automated testing</li><li>19 or `TrieV32` = V3.2 Trie</li><li>20 or `HashTrieV34` = V3.4 Hash Trie</li><li>21 or `CSV` = CSV file containing a dump of the data for the devices, browsers, etc that are used to generate the data file</li><li>27 or `HashV41` = Hash V4.1</li></ul> |
| Product        | The 51Degrees 'product' that the data file is part of. Accepts either the string or id from the list of values. | <ul><li>2 or `Premium` = The Premium V3 data file</li><li>4 or `Enterprise` = The Enterprise V3 data file</li><li>8 or `Lite` = The Lite V3 data file</li><li>15 or `TAC` = The TAC V3 data file</li><li>21 or `V4Free` = The free V4 data file</li><li>22 or `V4Enterprise` = The Enterprise V4 data file</li><li>23  or `V4TAC` = The TAC V4 data file</li></ul> |
| Download       | Legacy - Has no effect | True/False          |

## HTTP headers

### Response headers 

The server will respond with a `Content-MD5` header. This contains the MD5 hash of the data file content.
It can be used to verify the download by hashing the content and comparing the result with the value in this header.

The server will also respond with a `Last-Modified` header. This contains the publish date of the data file that is being downloaded.
This value should be used to populate the `If-Modified-Since` header on the next request (see request headers below).

If returning a 429 status (see response codes below), the server will specify an `Retry-After` header. This is the minimum number of seconds to wait before the distributor will serve requests for this License Key.

### Request headers

The sender may supply an [`If-Modified-Since`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Modified-Since) header. If present, the Distributor will check the date supplied in the header against the publish date for the latest data file.
If the data file is older or the same, the server will return HTTP status code 304.
If the data file is newer, it will be returned, along with HTTP 200.

## Response codes

| Response code | Meaning + Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 200           | Success. The content of the response message will include the requested data file.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| 300           | Multiple choices. There are multiple possible options for this License Key. You must specify the 'Product' parameter.                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| 304           | Not modified. The latest data file's publish date is not newer than the date supplied by the `If-Modified-Since` header (see request headers above).                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| 400           | Bad request. Check the URL is correct and that the required parameters are supplied. Also returned if the License Key is invalid                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| 403           | Forbidden. The supplied License Key has been revoked. Contact support@51degrees.com for assistance.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 404           | Not found. Usually indicates that a License Key has been supplied without a 'Product', and the Distributor has been unable to automatically determine which product you want. May also occur due to the supplied product and type being an invalid combination.                                                                                                                                                                                                                                                                                                                              | 
| 429           | Too many requests. Has a couple of causes <ul><li>You are over the threshold of requests per minute for this License Key. The server will specify a `Retry-After` header. Also see the 'Recommendations for large clusters' section at the bottom of the [data updates feature page](@ref PipelineApi_Features_AutomaticDatafileUpdates) for advice.</li><li>`Unable to update the data file successfully due to another process using the file.` This is an internal failure due to the way Distributor currently works. It should be resolved if you try again in a few minutes.</li></ul> |
| 500           | Internal server error. Some unexpected problem has occurred. Please try again later and contact support@51degrees.com if this continues.                                                                                                                                                                                                                                                                                                                                                                                                                                                     |



