const filterUrl = "/welcomes/filter";
const params = function () {
  return {
    locale: gon.locale,
    province_code: filterValue(".province_code"),
    district_code: filterValue(".district_code"),
  };
};

const onDistrictModalSave = function () {
  $(".btn-district-save").click(districtClickHandler);
};

const onProvinceModalSave = function () {
  $(".btn-province-save").click(provinceClickHandler);
};

const districtClickHandler = function (e) {
  e && e.preventDefault();
  if (params().district_code.length > 0) fetchDistrict();
  else resetDistrict();
  $("#districtsModal").modal("hide");
};

const provinceClickHandler = function (e) {
  e && e.preventDefault();
  if (params().province_code.length == 0) {
    resetProvince();
    resetDistrict();
  } else fetchProvince();
  $("#provincesModal").modal("hide");
};

const filterValue = function (ele) {
  return $(ele)
    .val()
    .filter((e) => e);
};

const fetchDistrict = function () {
  $.get(filterUrl, params(), function (result) {
    updateDistrict(result, params().district_code);
  });
};

const fetchProvince = function () {
  $.get(filterUrl, params(), responseProvince);
};

const responseProvince = function (result) {
  updateProvince(result, params().province_code);

  if (params().province_code.length == 1) {
    resetDistrict();
    pullDistricts(params().province_code);
  } else if (params().province_code.length > 1) {
    disableDistrict();
    resetDistrict();
  }
};

const updateDistrict = function (result, districtCode) {
  $("#show-districts").text(result.display_name);
  $("#q_districts").val(districtCode);
  $(".tooltip-district").attr("data-original-title", result.described_name);
};

const disableDistrict = function () {
  pumi.toggleEnableSelect(pumi.selectTarget("district"), false);
};

const pullDistricts = function (provinceCode) {
  pumi.filterSelectByValue(pumi.selectTarget("district"), provinceCode[0]);
};

const updateProvince = function (result, provinceCode) {
  $("#q_provinces").val(provinceCode);
  $("#show-provinces").text(result.display_name);
  $(".tooltip-province").attr("data-original-title", result.described_name);
};

const resetProvince = function () {
  $("#q_provinces").val("");
  $("#show-provinces").text(gon.all);
  $(".tooltip-province").attr("data-original-title", "");
};

const resetDistrict = function () {
  resetDistrictDisplay();
  resetDistrictValues();
};

const resetDistrictValues = function () {
  $("#q_districts").val("");
  $(".district_code").val(null).trigger("change");
};

const resetDistrictDisplay = function () {
  $("#show-districts").text(gon.all);
  $(".tooltip-district").attr("data-original-title", "");
};

export {
  onDistrictModalSave,
  onProvinceModalSave,
  districtClickHandler,
  provinceClickHandler,
};
