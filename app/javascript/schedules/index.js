OWSO.SchedulesNew = (() => {
  function init() {
    enableManualCron();
    initBootstrapToggle();
    addEventToDynamicVariables();
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

  function addEventToDynamicVariables() {
    onClickMessageVariables(".dynamic-variable");
  }

  function onClickMessageVariables(selectorKlass) {
    $(selectorKlass).click((e) => {
      e.preventDefault();

      text = $(e.target).text();
      var range = quill.getSelection(true);
      if (range) {
        if (range.length == 0) {
          quill.insertText(range.index, text, "silent");
        }
      }
    });
  }

  return { init };
})();

OWSO.SchedulesEdit = OWSO.SchedulesNew;
OWSO.SchedulesCreate = OWSO.SchedulesNew;
