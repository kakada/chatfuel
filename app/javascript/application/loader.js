document.addEventListener('turbolinks:load', function() {
  // $('[data-toggle="tooltip"]').tooltip();

  let currentPage = OWSO.Util.getCurrentPage();
  !!OWSO[currentPage] && OWSO[currentPage].init();
})
