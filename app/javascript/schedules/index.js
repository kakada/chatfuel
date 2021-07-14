OWSO.SchedulesNew = (() => {
  function init() {
    test();
  }

  function test() {
    $("#check_dev").change(function (e) {
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
