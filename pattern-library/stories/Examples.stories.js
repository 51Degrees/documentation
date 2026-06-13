// The shared building blocks for the SDK web examples (source/_patterns/06-examples),
// styled from the docs tokens. Composed pages live in ExamplePages.stories.js.
import { renderPattern } from './render-twig.js';

export default { title: "Examples/Components" };

export const Alert = () => renderPattern("examples-alert");
Alert.storyName = "alert";
export const ResultsTable = () => renderPattern("examples-results-table");
ResultsTable.storyName = "results-table (device)";
export const ResultsTableIp = () => renderPattern("examples-results-table-ip");
ResultsTableIp.storyName = "results-table (ip)";
export const EvidenceTable = () => renderPattern("examples-evidence-table");
EvidenceTable.storyName = "evidence-table";
export const HeadersTable = () => renderPattern("examples-headers-table");
HeadersTable.storyName = "headers-table";
export const IpForm = () => renderPattern("examples-ip-form");
IpForm.storyName = "ip-form";
export const Map = () => renderPattern("examples-map");
Map.storyName = "map";
export const Message = () => renderPattern("examples-message");
Message.storyName = "message";
