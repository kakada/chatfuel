import { onDistrictModalSave, onProvinceModalSave } from '../welcomes/locationSave'

OWSO.ListviewIndex = (() => {
  function init() {

    loadform()
    onDistrictModalSave()
    onProvinceModalSave()
  }

  function loadform() {
    Rails.fire(document.getElementById("q"), "submit");
  }

  return { init }
})()