// The documentation search component (c-search): input + results list.
export default {
  title: 'Components/Search',
};

export const Search = () => `
  <div class="l-docs-index">
    <div style="padding:24px;max-width:360px">
      <div class="g-search">
        <div class="c-search is-openable">
          <form class="c-search__form">
            <div class="b-form-group b-form-group--with-icon">
              <label for="inputSearch" class="b-text--hidden">Search</label>
              <img src="/images/icon-search.svg" class="b-icon" alt="Search" />
              <input type="text" class="c-search__input" id="inputSearch" placeholder="Start typing to find a property" aria-label="Search">
            </div>
          </form>
          <div class="c-search__content">
            <ul class="c-search__list">
              <li class="c-search__item">DeviceId</li>
              <li class="c-search__item">HardwareModel</li>
              <li class="c-search__item">PlatformName</li>
              <li class="c-search__item">BrowserName</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>`;
Search.storyName = 'Search';
