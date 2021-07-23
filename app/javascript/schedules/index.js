import tippy from "tippy.js";

OWSO.SchedulesNew = (() => {
  function init() {
    enableManualCron();
    initBootstrapToggle();
    addEventToDynamicVariables();
    loadTipsy();
  }

  function loadTipsy() {
    tippy("#info", {
      content: htmlContent(),
      allowHTML: true,
      placement: "right",
    });
  }

  function htmlContent() {
    let html = "";
    html += "Enable this option, so that we can define cron manualy: <br />";
    html += "set <code> day = *</code> means everyday <br />";
    html += "set <code> time = *:*</code> means every minute";
    return html;
  }

  function enableManualCron() {
    $("#enable_manual_cron").change(function (e) {
      if (this.checked) {
        $(".cron-control").prop("type", "text");
        $(".cron-control.cron-day").val("*");
        $(".cron-control.cron-time").val("*:*");
      } else {
        $(".cron-control").prop("type", "number");
        $(".cron-control.cron-day").val("1");
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

      let text = $(e.target).text();
      if (quill != undefined) {
        let range = quill.getSelection(true);
        if (range) {
          if (range.length == 0) {
            quill.insertText(range.index, text, "silent");
          }
        }
      }
    });
  }

  return { init };
})();

OWSO.SchedulesEdit = OWSO.SchedulesNew;
OWSO.SchedulesUpdate = OWSO.SchedulesNew;
OWSO.SchedulesCreate = OWSO.SchedulesNew;
