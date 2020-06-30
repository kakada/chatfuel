OWSO.SiteSettings = (() => {
  return {
    init
  }

  function init() {
    addEventToMessageVariable();
    addEventToDigestMessageVariable();
    initBootstrapToggle();
  }

  function initBootstrapToggle() {
    $('#toggle-notification').bootstrapToggle();
  }

  function addEventToMessageVariable() {
    onClickMessageVariables('.message-setting-variable', '#site_setting_message_template');
  }

  function addEventToDigestMessageVariable() {
    onClickMessageVariables('.digest-message-setting-variable', '#site_setting_digest_message_template');
  }

  function onClickMessageVariables(selectorKlass, domId) {
    $(selectorKlass).click((e) => {
      digestMessageVariable = $(e.target).text();
      digestMessageTemplateDom = $(domId);
      insertAtCursor(digestMessageTemplateDom[0], digestMessageVariable);
    });
  }

  function insertAtCursor (input, textToInsert) {
    const value = input.value;
    const start = input.selectionStart;
    const end = input.selectionEnd;

    input.value = value.slice(0, start) + textToInsert + value.slice(end);
    input.selectionStart = input.selectionEnd = start + textToInsert.length;
  }

})();

OWSO.SitesSettingsShow = OWSO.SiteSettings
