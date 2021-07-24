import { subCategoriesFeedback } from "../charts/citizen-feedback/feedback_sub_categories_chart";
import { overallFeedback } from "../charts/citizen-feedback/overall_rating_chart";
import { mostRequest } from "../charts/owso-information-accessed/most_request_service_access_chart";
import formater from "../data/formater";

OWSO.DashboardShow = (() => {
  function init() {
    OWSO.Charts.render();

    attachEventToCollapsedButton();
    attachEventToVariableFilter();
    renderDatetimepicker();
    onChangeProvince();
    onSubmitChooseDictionary();
    onClickChartkickLegend();
    attachEventClickToChartDownloadButton();
    multiSelectDistricts();
    tooltipChart();

    onLoadPopup();
    onChangePeriod();
    loadProvinceSubCategories();
    loadProvinceOverallRating();
    loadProvinceMostRequest();
  }

  function loadChart(instance, element, data) {
    if (data == undefined) data = {};

    instance.chartId = element;
    instance.ds = data;
    instance.render();
  }

  function loadProvinceMostRequest() {
    $(".chart_most_requested_services").each(function (_, dom) {
      let id = $(dom).data("provinceid");
      let data = gon.mostRequest[id];
      loadChart(mostRequest, dom.id, data);
    });
  }

  function loadProvinceOverallRating() {
    $(".chart_feedback_overall_rating").each(function (_, dom) {
      let id = $(dom).data("provinceid");
      let data = gon.overallRating[id] || {};
      loadChart(overallFeedback, dom.id, data);
    });
  }

  function loadProvinceSubCategories() {
    $(".chart_feedback_by_categories").each(function (_, dom) {
      let id = $(dom).data("provinceid");
      let data = gon.feedbackSubCategories[id];
      loadChart(subCategoriesFeedback, dom.id, data);
    });
  }

  function onChangePeriod() {
    $(document).on("change", ".period-filter", function () {
      let path = $(this).data("resourcepath");
      let url = `/welcomes/q/${path}`;

      let option = {
        url: url,
        target: this,
        extractor: formater[$(this).data("formater")],
        canvasId: $(this).data("canvasid"),
      };

      fetchResultSet(option);
    });
  }

  function fetchResultSet({ url, target, extractor, canvasId }) {
    let period = $(target).val();
    let serializedParams = $("#q").serialize() + `&period=${period}`;
    let header = $(target).closest(".card-header");
    let $spin = $(header.next().find(".loading")[0]);

    loading($spin);
    let chart = OWSO.Util.findChartInstance(canvasId);

    $.get(
      url,
      serializedParams,
      function (result) {
        chart.data = extractor(result);
        let max = _.max(OWSO.Util.flattenDataset(chart.data.datasets));
        let padding = chart.config.type == "horizontalBar" ? 1.75 : 1.4;
        let suggestedMax = Math.round(max * padding);

        chart.options.scales.yAxes[0].ticks.suggestedMax = suggestedMax;
        chart.options.scales.xAxes[0].ticks.suggestedMax = suggestedMax;

        chart.update();

        loaded($spin);
      },
      "json"
    );
  }

  function loading(spin) {
    spin.removeClass("d-none");
    spin.next().css({ opacity: 0.3 });
  }

  function loaded(spin) {
    spin.addClass("d-none");
    spin.next().css({ opacity: 1 });
  }

  function onLoadPopup() {
    $(".modal").on("show.bs.modal", function (event) {
      let btn = $(event.relatedTarget);

      let attrs = {
        provinceId: btn.data("provinceid"),
        callback: btn.data("callback"),
      };

      setupModal(attrs);
    });
  }

  function setupModal({ provinceId, callback }) {
    if (callback !== undefined) {
      OWSO.DashboardShow[callback](provinceId);
    }
  }

  function loadSubCategories(provinceId) {
    let elements = `.chart_feedback_by_sub_category[data-provinceid=${provinceId}]`;
    $(elements).each(function (_, dom) {
      let id = $(dom).data("id");
      let data = gon.feedbackSubCategories[id];
      loadChart(subCategoriesFeedback, dom.id, data);
    });
  }

  function tooltipChart() {
    $(".chart-name")
      .mouseover(function () {
        $(this).next().tooltip("show");
      })
      .mouseleave(function () {
        $(this).next().tooltip("hide");
      });
  }

  function multiSelectDistricts() {
    $(".select")
      .select2({
        theme: "bootstrap",
      })
      .on("select2:select", clearOtherFilterIfAllselected);
  }

  function clearOtherFilterIfAllselected(event) {
    let $districtCode = $("select.district_code");
    const ALL_VALUE = "";

    if (event.params.data.id == ALL_VALUE) {
      $districtCode.val(null).trigger("change");
    } else {
      $districtCode.val(_.without($(this).val(), ALL_VALUE)).trigger("change");
    }
  }

  function attachEventClickToChartDownloadButton() {
    $(document).on("click", ".chart-dl", function (e) {
      e.preventDefault();

      let target = $(e.currentTarget);
      let canvasId = $(this)
        .closest(".card-header")
        .next()
        .find(".chart-wrapper canvas")
        .prop("id");

      let chart = OWSO.Util.findChartInstance(canvasId);
      let name = target.data("name");
      download(chart.canvas, { name });
    });
  }

  function download(canvas, options) {
    let link = document.getElementById("link");

    link.setAttribute("download", `${options["name"] || "my-chart"}.png`);
    link.setAttribute("target", "_blank");
    link.setAttribute("href", canvas.toDataURL("image/png"));
    link.click();
  }

  function onClickChartkickLegend() {
    $(".chartjs-line-legend").click(function (e) {
      $(this).toggleClass("line-through");

      var index = $(this).data("chart-index");
      var ci = Chartkick.charts["chart-overview"].getChartObject();
      var meta = ci.getDatasetMeta(index);

      meta.hidden =
        meta.hidden === null ? !ci.data.datasets[index].hidden : null;

      ci.update();
    });
  }

  const START_DATE = "2020/08/28";
  function renderDatetimepicker() {
    flatpickr.localize(flatpickr.l10ns[gon.locale]);
    $(".datepicker_date").flatpickr({
      dateFormat: "Y/m/d",
      mode: "range",
      minDate: START_DATE,
      maxDate: "today",
      locale: {
        rangeSeparator: " - ",
      },
      defaultDate: [gon.start_date, gon.end_date],
      onChange: function (selectedDates, dateStr, instance) {
        const [startDate, endDate] = selectedDates;

        if (startDate != undefined && endDate != undefined) {
          $(".start_date").val(instance.formatDate(startDate, "Y/m/d"));
          $(".end_date").val(instance.formatDate(endDate, "Y/m/d"));
          $(".form").submit();
        }
      },
    });
  }

  function onChangeProvince() {
    $(document).on("change", "#province", function (e) {
      $("#district-hidden").val("");
    });
  }

  function attachEventToCollapsedButton() {
    $(".collapse-item").click(function (e) {
      e.preventDefault();
      $("input[type=radio]").attr("checked", false);

      let checkbox = $(this).prev("input[type=radio]");
      checkbox.attr("checked", true);
    });
  }

  function attachEventToVariableFilter() {
    $(".variable_filter").keyup(function (e) {
      var value = e.target.value.toLowerCase();

      $(this)
        .parent()
        .find(".accordion .card")
        .filter(function () {
          $(this).toggle(
            $(this).find("button").text().trim().toLowerCase().indexOf(value) >
              -1
          );
        });
    });
  }

  function onSubmitChooseDictionary() {
    $(".choose-dictionary-form").on(
      "ajax:success",
      function (e, data, status, xhr) {
        $(".modal").modal("hide");
        window.location.reload();
      }
    );
  }

  return {
    init,
    renderDatetimepicker,
    onChangeProvince,
    multiSelectDistricts,
    loadSubCategories,
  };
})();
