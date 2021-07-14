OWSO.SchedulesNew = (() => {
  function init() {
    enableManualCron();
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

  return { init };
})();
