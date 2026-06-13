// One story per web example type (source/_patterns/06-examples/1*.twig). Each page
// composes the example components and shows how a real example app renders.
import { renderPattern } from './render-twig.js';

export default { title: "Examples/Pages" };

export const DdGettingStarted = () => renderPattern("examples-dd-getting-started");
DdGettingStarted.storyName = "device detection - getting started";
export const DdClientOnly = () => renderPattern("examples-dd-client-only");
DdClientOnly.storyName = "device detection - client-side only";
export const DdClientHints = () => renderPattern("examples-dd-client-hints");
DdClientHints.storyName = "device detection - client hints";
export const IpGettingStarted = () => renderPattern("examples-ip-getting-started");
IpGettingStarted.storyName = "ip intelligence - getting started";
export const IpMixed = () => renderPattern("examples-ip-mixed");
IpMixed.storyName = "ip intelligence - mixed (device + ip)";

// Cloud free-tier message (cross-sells on-premise) — shown on the cloud examples.
export const DdGettingStartedCloudMessage = () => renderPattern("examples-dd-getting-started", { messageVariant: "cloud" });
DdGettingStartedCloudMessage.storyName = "message - cloud free tier (try on-premise)";

// On-premise Lite message (more properties/features) — generic, used by the IP examples.
export const IpGettingStartedOnPremMessage = () => renderPattern("examples-ip-getting-started", { messageVariant: "onpremise" });
IpGettingStartedOnPremMessage.storyName = "message - on-premise Lite (more properties)";

// On-premise Lite message listing the paid data file benefits — used by the device detection examples.
export const DdGettingStartedOnPremMessage = () => renderPattern("examples-dd-getting-started", { messageVariant: "onpremise-dd" });
DdGettingStartedOnPremMessage.storyName = "message - on-premise device detection (paid benefits)";

// Same page with the message toggled off (paid data file / full resource key).
export const DdGettingStartedPaid = () => renderPattern("examples-dd-getting-started", { showMessage: false });
DdGettingStartedPaid.storyName = "device detection - getting started (paid, no message)";
