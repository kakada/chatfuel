require("../patches/jquery")
import { renderChart } from '../charts/root_chart'
import { accessInfo } from '../charts/access_info_chart';
import { mostTrackedPeriodic } from '../charts/most_tracked_periodic_chart';

OWSO.WelcomesIndex = (() => {
  let logoContainer, formQuery, pilotHeader;

  let items = [
    { element: ".q_province", fromClass: "col-lg-2", toClass: "col-lg-4" },
    { element: ".q_district", fromClass: "col-lg-3", toClass: "col-lg-4" },
    { element: ".q_time_period", fromClass: "col-lg-3", toClass: "col-lg-3" }
  ];

  function init() {
    OWSO.DashboardShow.renderDatetimepicker();
    OWSO.DashboardShow.multiSelectDistricts();
    OWSO.DashboardShow.attachEventClickToChartDownloadButton();

    onWindowScroll();
    onChangeDistrict();
    onModalSave();
    onClickTabNavigation();
    onChangePeriod(); 
  }

  function onChangePeriod() {
    $(document).on("change", ".access-period", function() {
      fetchResultSet('/welcomes/q/access-info', this, accessInfo)
    })

    $(document).on("change", ".track-period", function() {
      fetchResultSet('/welcomes/q/service-tracked', this, mostTrackedPeriodic)
    })
  }

  function fetchResultSet(url, thiz, callback) {
    let period = $(thiz).val()
    let serializedParams = $('#q').serialize()+`&period=${period}`
    let header = $(thiz).closest(".card-header");
    let $spin = $(header.next().find(".fa-sync")[0]);

    loading($spin);

    $.get(url, serializedParams, function(result) {
      callback(result);
      loaded($spin);
    }, "json");
  }

  function loading(spin) {
    spin.removeClass("d-none");
    spin.next().css({ opacity: 0.3 });
  }

  function loaded(spin) {
    spin.addClass("d-none");
    spin.next().css({ opacity: 1 });
  }

  function onClickTabNavigation() {
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
      let target = $(e.target);
      let active = $(target).attr('href');
      $("#q_active_tab").val(active);
    })
  }

  function onModalSave() {
    $(".btn-save").click(function(e) {
      e.preventDefault();
      let provinceCode = $('#province').val();
      let districtCode = $('.district_code').val().filter( e => e);
      let params = { 
        province_code: provinceCode, 
        locale: gon.locale,
        district_code: districtCode 
      };

      if( districtCode.length > 0 ) {
        $.get("/welcomes/filter", params, function(result) {
          $("#show-districts").text(result.display_name);
          $("#q_districts").val(districtCode);
          $(".tooltip-district").attr("data-original-title", result.district_list_name);
        })
      } else {
        $("#show-districts").text(gon.all);
        $("#q_districts").val("");
      }

      $("#districtsModal").modal("hide");
    })
  }

  

  function onWindowScroll() {
    formQuery = $("#form-query");
    logoContainer = $("#logo-container");
    pilotHeader = $("#piloting-header");
    window.onscroll = () => { stickOnScroll() }
  }

  function onChangeDistrict() {
    $(document).on("change", "#district", function(e) {
      if( e.target.disabled ) {
        $("#time_period, #btn-search").prop("disabled", true);
      } else {
        $("#time_period, #btn-search").prop("disabled", false);
      }
    })
  }

  function stickOnScroll() {
    if(window.pageYOffset >= (logoContainer.outerHeight() + pilotHeader.offset().top) ) {
      $(".logo-inline").show();
      formQuery.addClass('highlight');
      $(".switch-lang").addClass('inc-top');
      decreaseFormControlWidth();
    } 
    
    if(window.pageYOffset < pilotHeader.offset().top) {
      $(".logo-inline").hide();
      formQuery.removeClass('highlight');
      $(".switch-lang").removeClass('inc-top');
      increaseFormControlWidth();
    }
  }

  function decreaseFormControlWidth() {
    $.each(items, function(_, item) {
      let { element, fromClass, toClass } = item;
      $(element).replaceClass(toClass, fromClass);
    })
  }

  function increaseFormControlWidth() {
    $.each(items, function(_, item) {
      let { element, fromClass, toClass } = item;
      $(element).replaceClass(fromClass, toClass);
    })
  }

  return { init, renderChart }

})()
