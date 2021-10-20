OWSO.DictionariesEdit = (() => {
  return {
    init,
    onClickMarkAs,
  };

  function init() {
    onClickRemoveValuePair();
    onClickAddValuePair();
    initTooltip();
    validateTextLimit();
    onClickMarkAs();
  }

  function onClickMarkAs() {
    $(document.body).on(
      "click",
      ".block-option--item:not(.block-option--item-disabled)",
      function (e) {
        e.preventDefault();

        let value = $(this).data("value");
        let input = $(this).find("input");
        let checked = input.prop("checked");

        input.prop("checked", !checked);
        if ($(this).find("input").attr("type") == "radio") {
          $(this)
            .siblings(".block-option--item")
            .not(this)
            .removeClass("block-option--item-active");
          if (value == gon.feedback_variable)
            $(".td-satisfied").toggleClass("invisible");
          else $(".td-satisfied").addClass("invisible");
        }

        $(this).toggleClass("block-option--item-active");
      }
    );
  }

  function validateTextLimit() {
    $(".input-hint").keyup(function () {
      let currentLength = $(this).val().length;
      let $hint = $(this).parent().next();
      $hint.text(`${currentLength}/${this.maxLength}`);

      if (currentLength >= this.maxLength) {
        $(this).addClass("is-invalid");

        return false;
      } else {
        $(this).removeClass("is-invalid");
      }
    });
  }

  function initTooltip() {
    $(".btn-circle").tooltip();
  }

  function onClickAddValuePair() {
    $("form .add_values").off("click");
    $("form .add_values").on("click", function (event) {
      appendField(this);
      event.preventDefault();
    });
  }

  function appendField(dom) {
    time = new Date().getTime();
    regexp = new RegExp($(dom).data("id"), "g");
    $(dom).parents("tr").before($(dom).data("fields").replace(regexp, time));
  }

  function onClickRemoveValuePair() {
    $(".table").on("click", ".dictionary-remove-pair", function (e) {
      e.preventDefault();
      var row = $(this).closest("tr");

      if (row.closest("tbody").children(".value-row").length > 1) {
        row.find(".variable-destroy").val(true);
        row.hide();
      } else {
        alert("Unable to empty dictionary");
      }
    });
  }
})();

OWSO.DictionariesUpdate = OWSO.DictionariesEdit;
