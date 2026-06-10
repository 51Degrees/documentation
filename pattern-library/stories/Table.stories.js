// Documentation data table (c-table). Heading row uses c-table__row--heading.
export default {
  title: 'Components/Table',
};

export const DataTable = () => `
  <div class="l-docs-index">
    <div class="g-main">
      <div class="g-docs__content">
        <div class="g-docs__primary" style="padding:24px">
          <table class="c-table">
            <tbody>
              <tr class="c-table__row c-table__row--heading">
                <td class="c-table__cell">Property</td>
                <td class="c-table__cell">Description</td>
              </tr>
              <tr class="c-table__row">
                <td class="c-table__cell"><code>id.usage</code></td>
                <td class="c-table__cell">The usage policy declared for the request.</td>
              </tr>
              <tr class="c-table__row">
                <td class="c-table__cell"><code>fodid.idprobglobal</code></td>
                <td class="c-table__cell">Global probabilistic identifier.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>`;
DataTable.storyName = 'Data table';
