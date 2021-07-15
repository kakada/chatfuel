OWSO.SchedulesNew = (() => {
  function init() {
    enableManualCron();
    initBootstrapToggle();
  }

  function enableManualCron() {
    $("#enable_manual_cron").change(function (e) {
      if (this.checked) {
        $(".cron-control").prop("type", "text");
      } else {
        $(".cron-control").prop("type", "number");
        $(".cron-control.cron-time").prop("type", "time");
      }
    });
  }

  function initBootstrapToggle() {
    $(".toggle-control").bootstrapToggle();
  }

  return { init };
})();

OWSO.SchedulesEdit = OWSO.SchedulesNew;
