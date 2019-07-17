var DOC_URL_BASE = 'documentation/';

/**
 * Get the documentation version from the URL.
 * @return the version string e.g. '4.0'.
 */
function getVersion() {
    var url = document.URL;
    return url.substring(url.indexOf(DOC_URL_BASE) + DOC_URL_BASE.length).split('/')[0];
}

/**
 * Update all the links in the example as they are relative.
 * @param project the repository name which the example came from
 * e.g. 'device-detection-cxx'.
 */
function updateLinks(project, divId) {
    var base = DOC_URL_BASE.split('/')[0];
    var as = $('#' + divId + ' a');
    for (i = 0; i < as.length; i++) {
        if (as[i].href.includes('/' + base + '/')) {
            // Replace the local part of the URL with the correct repository part
            // e.g. replace '/documentation/' with '/device-detection-cxx/'.
            as[i].href = as[i].href.replace('/' + base + '/', '/' + project + '/');
        }
    }
}

/**
 * Grab the example from the target language project, parse, and place in
 * the 'grabbed-example' div.
 * @param caller the button which called the function.
 * @param project the repository name to get the example from
 * e.g. 'device-detection-cxx'.
 * @param name the name of the example to get e.g. '_hash_2_getting_started_8cpp'.
 */
function grabExample(caller, project, name) {
    grabSnippet(
        caller,
        project,
        name + '-example.html',
        'primary',
        'examplebtn',
        'grabbed-example');
}

function grabSnippet(caller, project, file, tag, btnClass, divId) {
    selectBtn(caller, document.getElementsByClassName(btnClass));
    // Load the example into the 'grabbed-example' div, then update the links.
    $('#' + divId).load(
        '../../' + project + '/' + getVersion()
        + '/' + file
        + ' #' + tag,
        function() { updateLinks(project, divId); });

}

function selectBtn(caller, btns) {
    
    for (i = 0; i < btns.length; i++) {
        if (btns[i] === caller) {
            // This is the selected button, so highlight it.
            if (!btns[i].classList.contains('b-btn--tab--is-active')) {
                btns[i].classList.add('b-btn--tab--is-active');
            }
        }
        else if (btns[i].classList.contains('b-btn--tab--is-active')) {
            // This is not the selected button, and it is highlighted,
            // so un highlight it.
            btns[i].classList.remove('b-btn--tab--is-active');
        }
    }

}

function showSnippet(caller, language) {
    selectBtn(caller, caller.parentElement.children);
    var div = caller.parentElement;
    for (i = 0; i < div.children.length; i++) {
        var item = div.children.item(i);
        if (item.classList.contains("c-tabgroup__main")) {
            if (item.getAttribute("data-lang") === language) {
                item.style.display = "block";
            }
            else {
                item.style.display = "none";
            }
        }
    }
}