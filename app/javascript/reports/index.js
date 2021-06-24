OWSO.ReportsIndex = (() => {
  function init() {
    autoSubmit();
    OWSO.WelcomesIndex.init();
  }

  function autoSubmit() {
    $.rails.fire(document.getElementById("q"), "submit");
  }

  return { init };
})();
