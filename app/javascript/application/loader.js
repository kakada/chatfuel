$( document ).on('turbolinks:load', function() {
  var $body = $('body');
  OWSO.Util.closeAlert();
  let { dev, freshSession, isEmbed } = OWSO.Util;
  
  $body.tooltip({ selector: '[data-toggle="tooltip"]' });
  $body.popover({ selector: '[data-toggle="popover"]' });
  if( !dev() && !isEmbed() && freshSession() ) $('#popup').modal('show');

  let currentPage = OWSO.Util.getCurrentPage();
  !!OWSO[currentPage] && OWSO[currentPage].init();
})