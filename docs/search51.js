'use strict';

// The search box in the page header hands the visitor's question to the
// 51degrees.com assistant. The box starts hidden and is shown only when the
// assistant can answer for this visitor. Where the documentation is served
// without the assistant, the status request fails and the box stays hidden.
(function () {
    var STATUS_URL = '/api/v1/sid/status';
    var CHAT_URL = '/search-results?query=';

    // A question must be at least this many characters, once trimmed.
    var MIN_QUESTION_LENGTH = 3;

    // No answer from the status request within this time counts as not
    // ready.
    var STATUS_TIMEOUT_MS = 4000;

    // Longest wait for the cloud scripts before asking for the status
    // anyway. The analytics script announces even when it gives up, so this
    // only covers that script failing to run at all.
    var CLOUD_SCRIPTS_TIMEOUT_MS = 12000;

    // The chat page sends a question by itself only when it finds this key,
    // so a crawler opening a chat page address never starts a conversation.
    var TYPED_KEY = 'sidTypedQuestion';

    // The status depends on the 51Degrees cloud's view of the visitor, so it
    // is asked for once the cloud scripts have run in the page. The
    // 51degrees.com analytics script announces that with the fodscriptsran
    // event. A page without that script asks straight away.
    function afterCloudScripts(then) {
        if (window.fodScriptsRan ||
            !document.querySelector('script[data-fiftyone-analytics]')) {
            then();
            return;
        }
        var done = false;
        function go() {
            if (done) { return; }
            done = true;
            then();
        }
        window.addEventListener('fodscriptsran', go);
        window.setTimeout(go, CLOUD_SCRIPTS_TIMEOUT_MS);
    }

    // Calls then only when the status says the assistant is ready. A failed
    // request, a response that is not OK, or no answer in time all count as
    // not ready.
    function whenReady(then) {
        var done = false;
        var timer = window.setTimeout(function () {
            done = true;
        }, STATUS_TIMEOUT_MS);
        fetch(STATUS_URL, { cache: 'no-store', credentials: 'same-origin' })
            .then(function (r) { return r.ok ? r.json() : null; })
            .then(function (data) {
                window.clearTimeout(timer);
                if (done || !data || data.ready !== true) { return; }
                done = true;
                then();
            })
            .catch(function () { window.clearTimeout(timer); });
    }

    function ask(question) {
        // Storage can be blocked, in which case the chat page puts the
        // question in its box for the visitor to send.
        try {
            window.sessionStorage.setItem(TYPED_KEY, question);
        } catch (e) { }
        window.location.href = CHAT_URL + encodeURIComponent(question);
    }

    function start() {
        var box = document.querySelector('.g-search');
        var form = box && box.querySelector('form');
        var input = document.getElementById('inputSearch');
        if (!form || !input) { return; }
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            var question = input.value.trim();
            if (question.length < MIN_QUESTION_LENGTH) {
                input.focus();
                return;
            }
            ask(question);
        });
        afterCloudScripts(function () {
            whenReady(function () {
                box.removeAttribute('hidden');
            });
        });
    }

    // The header and the analytics script come after this script in the
    // page, so wait for the document to be parsed.
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }
})();
