$( document ).on('turbolinks:load', function() {
  var $body = $('body');
  OWSO.Util.closeAlert();
  let { dev, freshSession } = OWSO.Util;
  
  $body.tooltip({ selector: '[data-toggle="tooltip"]' });
  $body.popover({ selector: '[data-toggle="popover"]' });
  if( !dev() && freshSession() ) $('#popup').modal('show');

  let currentPage = OWSO.Util.getCurrentPage();
  !!OWSO[currentPage] && OWSO[currentPage].init();
})