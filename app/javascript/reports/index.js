OWSO.ReportsIndex = (() => {
  function init() {
    autoSubmit();
    OWSO.WelcomesIndex.init();
  }

  function autoSubmit() {
    let form = document.getElementById("q");

    $.rails.fire(form, "submit");
  }

  return { init, autoSubmit };
})();
