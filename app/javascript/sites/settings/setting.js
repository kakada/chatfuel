OWSO.SitesSettingsIndex = (() => {
  return {
    init,
  };

  function init() {
    addEventToMessageVariable();
    addEventToDigestMessageVariable();
    initBootstrapToggle();
    handleSwitchingMessageTemplate();
    onChangeMessageFrequency();
  }

  function onChangeMessageFrequency() {
    $("#site_feedback_setting_message_frequency").on("change", (e) => {
      handleSwitchingMessageTemplate(e.currentTarget.value);
    });
  }

  function handleSwitchingMessageTemplate(value) {
    let selectedValue =
      value || $("#site_feedback_setting_message_frequency").val();

    if (selectedValue == "1") {
      $(".site_feedback_setting_message_template").show();
      $(".site_feedback_setting_digest_message_template").hide();
      return;
    }

    $(".site_feedback_setting_message_template").hide();
    $(".site_feedback_setting_digest_message_template").show();
  }

  function initBootstrapToggle() {
    $(".toggle-notification").bootstrapToggle();
  }

  function addEventToMessageVariable() {
    onClickMessageVariables(
      ".message-setting-variable",
      "#site_feedback_setting_message_template"
    );
  }

  function addEventToDigestMessageVariable() {
    onClickMessageVariables(
      ".digest-message-setting-variable",
      "#site_feedback_setting_digest_message_template"
    );
  }

  function onClickMessageVariables(selectorKlass, domId) {
    $(selectorKlass).click((e) => {
      digestMessageVariable = $(e.target).text();
      digestMessageTemplateDom = $(domId);
      insertAtCursor(digestMessageTemplateDom[0], digestMessageVariable);
    });
  }

  function insertAtCursor(input, textToInsert) {
    const value = input.value;
    const start = input.selectionStart;
    const end = input.selectionEnd;

    input.value = value.slice(0, start) + textToInsert + value.slice(end);
    input.selectionStart = input.selectionEnd = start + textToInsert.length;
  }
})();

OWSO.SitesSettingsShow = OWSO.SitesSettingsIndex;
