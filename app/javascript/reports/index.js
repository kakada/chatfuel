OWSO.ReportsIndex = (() => {
  function init() {
    autoSubmit();
    OWSO.WelcomesIndex.init();
  }

  function autoSubmit() {
    let form = document.getElementById("q");

    $(form)
      .on("ajax:before", function () {
        $(".loading").show();
      })
      .on("ajax:complete", function () {
        $(".loading").hide();
      });

    $.rails.fire(form, "submit");
  }

  return { init };
})();
