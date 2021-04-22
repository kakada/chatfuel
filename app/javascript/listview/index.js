import { onDistrictModalSave, onProvinceModalSave } from '../welcomes/locationSave'

OWSO.ListviewIndex = (() => {
  function init() {
    OWSO.DashboardShow.attachEventClickToChartDownloadButton();

    loadform()
    onDistrictModalSave()
    onProvinceModalSave()
  }

  function loadform() {
    $.rails.fire(document.getElementById("q"), "submit");
  }

  return { init }
})()
