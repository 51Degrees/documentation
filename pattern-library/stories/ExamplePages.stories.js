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

// Same page with the message toggled off (paid data file / full resource key).
export const DdGettingStartedPaid = () => renderPattern("examples-dd-getting-started", { showMessage: false });
DdGettingStartedPaid.storyName = "device detection - getting started (paid, no message)";
