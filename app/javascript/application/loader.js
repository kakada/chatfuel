// document.addEventListener('turbolinks:load', function() {
//   // $('[data-toggle="tooltip"]').tooltip();

//   let currentPage = OWSO.Util.getCurrentPage();
//   !!OWSO[currentPage] && OWSO[currentPage].init();
// })

$(document).on("turbolinks:load", function () {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  $(".toggle-control").bootstrapToggle();
  OWSO.Util.closeAlert();

  let currentPage = OWSO.Util.getCurrentPage();
  !!OWSO[currentPage] && OWSO[currentPage].init();
});
