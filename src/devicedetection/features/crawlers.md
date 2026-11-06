@page DeviceDetection_Features_Crawlers Crawlers

# Overview

Key crawler properties include `CrawlerUsage` and `CrawlerProductTokens`. `CrawlerUsage` lists how the crawler uses collected data. We assign one or more usage values based on information published by the crawler operator and our research.


# Values

Control what your content can be used for by checking the `CrawlerUsage` property. These values are based on the [RSL 1.0 Specification - 3.4.1.1 Usage Vocabulary](https://rslstandard.org/rsl#_3-4-1-1-usage-vocabulary) and we have expanded to include non-AI related crawler usages.

- **Index** Indicates that the crawler is used to gather content for inclusion in an AI system’s internal index or retrieval database.

- **Train** Indicates that the crawler is used to train or fine-tune AI models.

- **Input** Indicates that the crawler is used to collect content for input into AI models, including retrieval-augmented generation, grounding, or other use of the content to produce generative AI responses or search summaries.

- **Search** Indicates that the crawler is used to build search indexes and provide search results. Search does not include the AI uses covered by the Index and Input categories.

- **Monitor** Indicates that the crawler is used for monitoring websites. This crawling primarily involves regular visits to selected web pages to validate that they respond as expected.

- **Archiving** Indicates that the crawler is used for archiving data and websites.

- **Preview** Indicates that the crawler is used to create content previews.

- **Security** Indicates that the crawler is a security-focused web crawler that scans domains for vulnerabilities.

- **Analytics** Indicates that the crawler is used to gather data for marketing analytics.

- **Feed** Indicates that the crawler is used for aggregating news, information, or data.

- **Discovery** Indicates that the crawler gathers information about a website's discoverability or search ranking, primarily for search engine optimization (SEO).


# IsArtificialIntelligence

`IsArtificialIntelligence` is a property designed to give you easy answers about AI crawling. If the crawler has a `CrawlerUsage` related to AI this will be True.

- **True** The crawler is confirmed by the controller to be used to train artificial intelligence.

- **False** The crawler is not used to train artificial intelligence. This may be based on the controller documentation or on the capabilities and purpose of the crawler. For crawlers which do not read website content it is assumed they cannot be used to train artificial intelligence.

- **Unknown** It is not possible to determine whether the crawler is being used to train artificial intelligence.

- **N/A** Not a crawler.


# Signed agents

`IsCrawler` and the other crawler properties tell you what an agent declares about itself. An @agentsignature tells you what an agent has proved. The two are used together.

A crawler declares itself through its User-Agent header, and any other program can send the same header, so a declaration is a claim. Under the IETF Web Bot Auth protocol an agent instead signs its request with a private key and publishes the matching public key on its own site. That signature either checks out or it does not, and it cannot be produced without the private key, so `AgentSignature` is proof where `IsCrawler` is a claim.

Only a handful of agents sign today, so most requests report the `Absent` status and an absent signature is never evidence against a request. See @ref PipelineApi_Features_AgentSignature for the properties, the statuses and how to add the feature to your @Pipeline.


# Robots.txt

We use these properties for our [Robots.txt generator](https://51degrees.com/robots-txt) so that you can allow or disallow crawlers by `CrawlerUsage`.
