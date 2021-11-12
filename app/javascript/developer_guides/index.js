OWSO.Developer_guidesIndex = (() => {
  function init() {
    hljs.highlightAll();
  }

  $(document).on("click", ".js-copy", function () {
    var text = $(this).attr("data-copy");
    var el = $(this);
    copyToClipboard(text, el);
  });

  function copyToClipboard(text, el) {
    var copyTest = document.queryCommandSupported("copy");
    var elOriginalText = el.attr("data-original-title");

    if (copyTest === true) {
      var copyTextArea = document.createElement("textarea");
      copyTextArea.value = text;
      document.body.appendChild(copyTextArea);
      copyTextArea.select();
      try {
        var successful = document.execCommand("copy");
        var msg = successful ? "Copied!" : "Whoops, not copied!";
        el.attr("data-original-title", msg).tooltip("show");
      } catch (err) {
        console.log("Oops, unable to copy");
      }
      document.body.removeChild(copyTextArea);
      el.attr("data-original-title", elOriginalText);
    } else {
      window.prompt("Copy to clipboard: Ctrl+C or Command+C, Enter", text);
    }
  }

  return { init };
})();
