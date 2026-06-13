// Pages for the configurator surface. Same approach as Examples/Pages: one
// story per page, rendered from source/_patterns.
import { renderPattern } from './render-twig.js';

export default { title: "Configurator/Pages" };

export const ConfIndex = () => renderPattern("layouts-conf-index");
ConfIndex.storyName = "configurator index";
export const Configure = () => renderPattern("pages-configure");
Configure.storyName = "configure";
export const Details = () => renderPattern("pages-details");
Details.storyName = "details";
export const Implement = () => renderPattern("pages-implement");
Implement.storyName = "implement";
export const Share = () => renderPattern("pages-share");
Share.storyName = "share";
