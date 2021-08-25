require("../patches/jquery");
import { districtClickHandler, provinceClickHandler } from "./locationSave";

OWSO.WelcomesIndex = (() => {
  let logoContainer, formQuery, pilotHeader;

  let items = [
    { element: ".q_province", fromClass: "col-lg-2", toClass: "col-lg-4" },
    { element: ".q_district", fromClass: "col-lg-3", toClass: "col-lg-4" },
    { element: ".q_time_period", fromClass: "col-lg-3", toClass: "col-lg-3" },
  ];

  function init() {
    OWSO.DashboardShow.multiSelectDistricts();
    OWSO.DashboardShow.renderDatetimepicker();
    OWSO.DashboardShow.attachEventClickToChartDownloadButton();
    OWSO.DashboardShow.tooltipChart();
    OWSO.DashboardShow.onChangePeriod();

    onWindowScroll();
    onChangeDistrict();
    onClickTabNavigation();
    ssbInterceptor();
    loadCookieConsent();
    onLocationKeyEnterPress();
    onLoadLocationPopup();
    switchLang();
    checkDirtyForm();
  }

  function checkDirtyForm() {
    $(document).on(
      "change",
      ".province_code, .district_code, .datepicker_date",
      function () {
        if ($(this).val() != "") $("#q_dirty").val(true);
      }
    );
  }

  function switchLang() {
    $(document).on("click", ".lang-item", function (e) {
      e.preventDefault();
      let currentLocale = $(this).data("locale");
      $("#q_locale").val(currentLocale);
      OWSO.ReportsIndex.autoSubmit();
    });
  }

  function onLoadLocationPopup() {
    $(document).on("shown.bs.modal", ".modal", function (event) {
      $(event.target).find("select").select2("open");
    });
  }

  function loadCookieConsent() {
    cookieconsent.initialise({
      palette: {
        popup: {
          background: "#000",
        },
        button: {
          background: "#f1d600",
        },
      },
      position: "bottom-left",
      content: {
        href: gon.cookiePolicyPath,
      },
    });
  }

  function onLocationKeyEnterPress() {
    $("#show-provinces, #show-districts").keydown(function (event) {
      let keyCode = event.keyCode ? event.keyCode : event.which;
      const KEY_ENTER = 13;

      if (keyCode == KEY_ENTER) {
        $(this).trigger("click");
      }
    });
  }

  function ssbInterceptor() {
    $(".ssb-icon").click(function () {
      let site = $(this).data("site");

      $.ajax({
        url: "/api/v1/social_providers",
        type: "post",
        data: { social_provider: { provider_name: site } },
        dataType: "json",
      });
    });
  }

  function onClickTabNavigation() {
    $(document).on("shown.bs.tab", 'a[data-toggle="tab"]', function (e) {
      var target = $(e.target);
      var active = $(target).attr("href");
      $("#q_active_tab").val(active);
    });
  }

  function onWindowScroll() {
    formQuery = $("#form-query");
    logoContainer = $("#logo-container");
    pilotHeader = $("#piloting-header");
    window.onscroll = () => {
      stickOnScroll();
    };
  }

  function onChangeDistrict() {
    $(document).on("change", "#district", function (e) {
      if (e.target.disabled) {
        $("#time_period, #btn-search").prop("disabled", true);
      } else {
        $("#time_period, #btn-search").prop("disabled", false);
      }
    });
  }

  function stickOnScroll() {
    // Additional padding to prevent early or late
    // highlighting floating header
    let scroll = { DOWN: 60, UP: 9 };

    if (
      window.pageYOffset >=
      logoContainer.outerHeight() + pilotHeader.offset().top - scroll.UP
    ) {
      $(".logo-inline").show();
      formQuery.addClass("highlight");
      $(".switch-lang").addClass("inc-top");
      decreaseFormControlWidth();
    }

    if (
      window.pageYOffset == 0 ||
      window.pageYOffset < pilotHeader.offset().top - scroll.DOWN
    ) {
      $(".logo-inline").hide();
      formQuery.removeClass("highlight");
      $(".switch-lang").removeClass("inc-top");
      increaseFormControlWidth();
    }
  }

  function decreaseFormControlWidth() {
    $.each(items, function (_, item) {
      let { element, fromClass, toClass } = item;
      $(element).replaceClass(toClass, fromClass);
    });
  }

  function increaseFormControlWidth() {
    $.each(items, function (_, item) {
      let { element, fromClass, toClass } = item;
      $(element).replaceClass(fromClass, toClass);
    });
  }

  function scrollToForm() {
    if (window.matchMedia("(min-width: 767px)").matches) {
      let formQuery = $("#form-query");
      const PADDING = 40;
      $([document.documentElement, document.body]).animate(
        {
          scrollTop: formQuery.offset().top + PADDING,
        },
        500
      );
    }
  }

  return {
    init,
    scrollToForm,
    onWindowScroll,
    districtClickHandler,
    provinceClickHandler,
  };
})();
