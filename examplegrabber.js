var DOC_URL_BASE = 'documentation/docs/';

function getVersion() {
    var url = document.URL;
    return url.substring(url.indexOf(DOC_URL_BASE) + DOC_URL_BASE.length).split('/')[0];
}

function updateLinks(project) {
    var base = DOC_URL_BASE.split('/')[0];
    var as = $('#grabbed-example a');
    for (i = 0; i < as.length; i++) {
        if (as[i].href.includes('/' + base + '/')) {
            as[i].href = as[i].href.replace('/' + base + '/', '/' + project + '/');
        }
    }
}

function grabExample(caller, project, name) {
    var btns = document.getElementsByClassName('examplebtn');
    for (i = 0; i < btns.length; i++) {
        if (btns[i] === caller) {
            btns[i].classList.remove('b-btn--secondary');
        }
        else if (!btns[i].classList.contains('b-btn--secondary')) {
            btns[i].classList.add('b-btn--secondary');
        }
    }
    $('#grabbed-example').load(
        '../../../' + project + '/docs/' + getVersion()
        + '/' + name + '-example.html'
        + ' #primary',
        function() {updateLinks(project)})
}