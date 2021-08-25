const onDistrictModalSave = function () {
  $(".btn-district-save").click(districtClickHandler);
};

function districtClickHandler(e) {
  e && e.preventDefault();
  if (filterValue(".district_code").length > 0) {
    fetchDistrict();
  } else {
    resetDistrict();
  }
  $("#districtsModal").modal("hide");
}

const onProvinceModalSave = function () {
  $(".btn-province-save").click(provinceClickHandler);
};

function provinceClickHandler(e) {
  e && e.preventDefault();
  if (filterValue(".province_code").length == 0) {
    resetProvince();
    resetDistrict();
  } else {
    fetchProvince();
  }
  $("#provincesModal").modal("hide");
}

function filterValue(ele) {
  return $(ele)
    .val()
    .filter((e) => e);
}

function fetchDistrict() {
  $.get(
    "/welcomes/filter",
    {
      locale: gon.locale,
      province_code: filterValue(".province_code"),
      district_code: filterValue(".district_code"),
    },
    function (result) {
      updateDistrict(result, filterValue(".district_code"));
    }
  );
}

function fetchProvince() {
  let provinceCode = filterValue(".province_code");

  $.get(
    "/welcomes/filter",
    {
      locale: gon.locale,
      province_code: provinceCode,
    },
    function (result) {
      updateProvince(result, provinceCode);

      if (provinceCode.length == 1) {
        resetDistrict();
        pullDistricts(provinceCode);
      } else if (provinceCode.length > 1) {
        disableDistrict();
        resetDistrict();
      }
    }
  );
}

function updateDistrict(result, districtCode) {
  $("#show-districts").text(result.display_name);
  $("#q_districts").val(districtCode);
  $(".tooltip-district").attr("data-original-title", result.described_name);
}

function disableDistrict() {
  pumi.toggleEnableSelect(pumi.selectTarget("district"), false);
}

function pullDistricts(provinceCode) {
  pumi.filterSelectByValue(pumi.selectTarget("district"), provinceCode[0]);
}

function updateProvince(result, provinceCode) {
  $("#q_provinces").val(provinceCode);
  $("#show-provinces").text(result.display_name);
  $(".tooltip-province").attr("data-original-title", result.described_name);
}

function resetProvince() {
  $("#q_provinces").val("");
  $("#show-provinces").text(gon.all);
  $(".tooltip-province").attr("data-original-title", "");
}

function resetDistrict() {
  // disableDistrict();
  resetDistrictDisplay();
  resetDistrictValues();
}

function resetDistrictValues() {
  $("#q_districts").val("");
  $(".district_code").val(null).trigger("change");
}

function resetDistrictDisplay() {
  $("#show-districts").text(gon.all);
  $(".tooltip-district").attr("data-original-title", "");
}

export {
  onDistrictModalSave,
  onProvinceModalSave,
  fetchProvince,
  fetchDistrict,
  districtClickHandler,
  provinceClickHandler,
};
