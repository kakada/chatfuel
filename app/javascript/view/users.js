OWSO.UsersIndex = (() => {
  return {
    init,
  };

  function init() {
    onChangeAvataFile();
    onClickButtonDeleteAvatar();
    OWSO.DictionariesEdit.onClickMarkAs();
  }

  function onClickButtonDeleteAvatar() {
    $(".btn-delete").on("click", function () {
      showDefaultImage();
      hideDeleteButton();
      setCheckRemoveAvatar();
    });
  }

  function onChangeAvataFile() {
    $("#user_avatar").change(function () {
      readURL(this);
      showButtonDelete();
      setUncheckRemoveAvatar();
    });
  }

  function setCheckRemoveAvatar() {
    $("#user_remove_avatar").attr("checked", true);
  }

  function showDefaultImage() {
    $(".user-avata").attr("src", $(".user-avata").data("default"));
  }

  function hideDeleteButton() {
    $(".btn-delete").addClass("d-none");
  }

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $(".user-avata").attr("src", e.target.result);
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  function showButtonDelete() {
    $(".btn-delete").removeClass("d-none");
  }

  function setUncheckRemoveAvatar() {
    $("#user_remove_avatar").attr("checked", false);
  }
})();

OWSO.UsersNew = OWSO.UsersIndex;
