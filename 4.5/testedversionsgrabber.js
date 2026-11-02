
var gitHubRunners = undefined;

/**
 * Populate gitHubRunners synchronously from the readme of GitHub's runner
 * images, so that when this function returns the list is ready. If the
 * readme cannot be read the list stays empty, and each platform is then
 * shown by the label its entry names.
 */
function populateImages() {
    gitHubRunners = [];
    $.ajax({
        url: 'https://raw.githubusercontent.com/actions/runner-images/main/README.md',
        success: function(markdown) {
            gitHubRunners = getRunners(markdown);
        },
        async: false
    });
}

/**
 * Get the platform title with an HTML link to its list of software, using
 * the label an entry in 'ci/options.json' gives as its image.
 * @param {string} image label of the image e.g. ubuntu-latest
 * @returns HTML link, or the label itself when GitHub no longer lists it
 */
function getPlatform(image) {
    if (gitHubRunners === undefined) {
        populateImages();
    }
    var runner = getRunner(image, gitHubRunners);
    if (runner === undefined) {
        return image;
    }
    if (runner.link === undefined) {
        return runner.title;
    }
    return `<a href="${runner.link}">${runner.title}</a>`;
}

/**
 * Get the runner which answers to the label supplied.
 * @param {string} name label of the runner e.g. ubuntu-latest
 * @param {Array} runners runners read from the GitHub runner images readme
 * @returns runner object with its labels, title and link, or undefined
 */
function getRunner(name, runners) {
    for (let i = 0; i < runners.length; i++) {
        if (runners[i].labels.indexOf(name) >= 0) {
            return runners[i];
        }
    }
    return undefined;
}

/**
 * Get every runner image from the table of images in the readme. The
 * columns are found by their headings, so a column GitHub adds or moves
 * does not stop the lookup.
 * @param {string} markdown full markdown file
 * @returns array of runners, each with its labels, title and link
 */
function getRunners(markdown) {
    var lines = markdown.split(/\r?\n/);
    var links = getLinks(lines);
    var runners = [];
    var columns = undefined;
    for (let i = 0; i < lines.length; i++) {
        if (lines[i].indexOf('|') !== 0) {
            columns = undefined;
            continue;
        }
        var cells = getCells(lines[i]);
        if (columns === undefined) {
            if (cells.indexOf('Image') >= 0 && cells.indexOf('YAML Label') >= 0) {
                columns = {
                    image: cells.indexOf('Image'),
                    label: cells.indexOf('YAML Label'),
                    software: cells.indexOf('Included Software')
                };
            }
            continue;
        }
        if (/^[\s:-]*$/.test(cells.join(''))) {
            continue;
        }
        var labels = (cells[columns.label] || '').match(/`[^`]+`/g) || [];
        runners[runners.length] = {
            labels: labels.map(l => l.slice(1, -1)),
            title: (cells[columns.image] || '').split('<br>')[0].trim(),
            link: columns.software >= 0 ? links[cells[columns.software]] : undefined
        };
    }
    return runners;
}

/**
 * Split a markdown table row into its trimmed cells.
 * @param {string} line markdown table row
 * @returns array of cell contents
 */
function getCells(line) {
    return line.replace(/^\|/, '').replace(/\|\s*$/, '').split('|').map(c => c.trim());
}

/**
 * Get link addresses from every link definition in the readme, keyed on the
 * name in square brackets, which is how the table's Included Software
 * column refers to them.
 * @param {Array} lines lines of the markdown file
 * @returns object where keys = names including square brackets, and values = links
 */
function getLinks(lines) {
    var links = {};
    for (let i = 0; i < lines.length; i++) {
        var match = /^(\[[^\]]+\]):\s*(\S+)/.exec(lines[i]);
        if (match) {
            links[match[1]] = match[2];
        }
    }
    return links;
}

/**
 * Get the links to a repository's latest release and to the runs of the
 * workflow which tests it on the main branch.
 * @param {string} repository address of the repository on GitHub
 * @param {string} workflow file name of the workflow
 * @returns HTML paragraph
 */
function getCiLinks(repository, workflow) {
    return `<p><a href="${repository}/releases/latest">Latest release</a> | ` +
        `<a href="${repository}/actions/workflows/${workflow}?query=branch%3Amain">Test runs</a></p>`;
}

/**
 * Populate the div with the id provided with a table containing the versions of OS etc.
 * which the repository provided is tested against, followed by links to the
 * repository's latest release and to its test runs.
 * The JSON file in 'ci/options.json' is used to populate, where the runner image is looked
 * up in GitHub runners, and the other dimensions are determined using functions passed as keys.
 * @param {string} project name of the repository
 * @param {string} divId id of the div to populate
 * @param {object} keys names and get functions for each testing dimension
 * e.g. { title: "Architecture", getValue: (d) => d.Arch }, or an empty array
 * to list the platforms alone
 * @param {string} product optional, for a repository holding several products,
 * the product whose entries to show, matched against each entry's 'Products'
 * @param {string} workflow optional, the file name of the workflow whose runs
 * test the entries, nightly-pipeline.yml when not given
 */
function grabTestedVersions(project, divId, keys, product, workflow) {
    var repository = `https://github.com/51Degrees/${project}`;
    var optionsUrl = `https://raw.githubusercontent.com/51Degrees/${project}/main/ci/options.json`;
    var ciLinks = getCiLinks(repository, workflow || 'nightly-pipeline.yml');
    $.getJSON(optionsUrl, function(options) {
        var platforms = {};

        for (let i = 0; i < options.length; i++) {
            if (product && !(options[i].Products || []).includes(product)) {
                continue;
            }
            var name = options[i].Image;
            if (Object.keys(platforms).indexOf(name) < 0) {
                platforms[name] = [];
            }
            if (hasConfig(platforms[name], options[i], keys) === false) {
                platforms[name][platforms[name].length] = options[i];
            }
        }
        var heading = cell('Platform');
        if (keys.length > 0) {
            heading += cell('Tested Configurations');
        }
        var table = '<div class="g-table g-table--overflow"><table class="c-table">';
        table += '<tbody>';
        table += `<tr class="c-table__row--heading">${heading}</tr>`;
        for (const [platform, configs] of Object.entries(platforms)) {
            table += '<tr>';
            table += cell(getPlatform(platform));
            if (keys.length > 0) {
                var list = '<ul>';
                for (let i = 0; i < configs.length; i++) {
                    list += '<li>';
                    for (let j = 0; j < keys.length; j++) {
                        list += `${keys[j].title}: ${keys[j].getValue(configs[i])} `;
                    }
                    list += '</li>';
                }
                list += '</ul>';
                table += cell(list);
            }
            table += '</tr>';
        }
        table += '</tbody>';
        table += '</table></div>';
        $('#' + divId).html(table + ciLinks);
    }).fail(function() {
        $('#' + divId).html(
            `<p>The tested versions could not be read from <a href="${repository}/blob/main/ci/options.json">ci/options.json</a>.</p>` +
            ciLinks);
    });
}

/**
 * Get an HTML table cell with the correct class.
 * @param {string} content string content to add in the cell
 * @returns HTML formatted cell
 */
function cell(content) {
    return `<td class="c-table__cell">${content}</td>`
}

/**
 * Determine whether or a list of configs contains a config already, using the
 * keys supplied to compare.
 * @param {Array} configs array to search
 * @param {object} config config to search for
 * @param {Array} keys array of keys to compare (see grabTestedVersions for structure)
 * @returns true if config is found
 */
function hasConfig(configs, config, keys) {
    for (let i = 0; i < configs.length; i++) {
        if (configsAreEqual(configs[i], config, keys)) {
            return true;
        }
    }
    return false;
}

/**
 * Determine whether two configs are equal, using the keys supplied to compare.
 * @param {object} first config to compare
 * @param {object} second other config to compare
 * @param {Array} keys array of keys to compare (see grabTestedVersions for structure)
 * @returns true if configs are equal
 */
function configsAreEqual(first, second, keys) {
    for (let i = 0; i < keys.length; i++) {
        var key = keys[i];
        if (key.getValue(first) != key.getValue(second)) {
            return false;
        }
    }
    return true;
}