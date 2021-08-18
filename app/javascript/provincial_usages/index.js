import * as htmlToImage from "html-to-image";
import download from "downloadjs";
window.moment = require("moment/moment");

OWSO.Provincial_usagesIndex = (() => {
  function init() {
    OWSO.DashboardShow.renderDatetimepicker();
    OWSO.DashboardShow.onChangeProvince();
    OWSO.DashboardShow.multiSelectDistricts();
    downloadImage();
  }

  function downloadImage() {
    $("#downloadImage").click(function (e) {
      e.preventDefault();
      htmlToImage
        .toPng(document.getElementById("table"), {
          backgroundColor: "white",
          style: { color: "black" },
        })
        .then(function (dataUrl) {
          download(dataUrl, `${gon.fileName}.png`);
        })
        .catch(function (err) {
          console.log(err.message);
        });
    });
  }
  return { init };
})();
