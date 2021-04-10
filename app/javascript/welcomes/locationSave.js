const onDistrictModalSave = function() {
  $(".btn-district-save").click(function(e) {
    e.preventDefault();
    let provinceCode = $('.province_code').val().filter( e => e);
    let districtCode = $('.district_code').val().filter( e => e);

    let params = { 
      locale: gon.locale,
      province_code: provinceCode, 
      district_code: districtCode 
    };

    if( districtCode.length > 0 ) {
      $.get("/welcomes/filter", params, function(result) {
        updateDistrict(result, districtCode);
      })
    } else {
      resetDistrict();
    }

    $("#districtsModal").modal("hide");
  })
}

const onProvinceModalSave = function() {
  $(".btn-province-save").click(function(e) {
    e.preventDefault();
    let provinceCode = $('.province_code').val().filter( e => e);
    let params = { 
      locale: gon.locale,
      province_code: provinceCode 
    };

    if( provinceCode.length == 0 ) {
      resetProvince();
      disableDistrict();
      resetDistrict();
    } else  {
      $.get("/welcomes/filter", params, function(result) {
        updateProvince(result, provinceCode);

        if ( provinceCode.length == 1 ) {
          resetDistrict();
          pullDistricts(provinceCode);
        } else if ( provinceCode.length > 1 ) {
          disableDistrict();
          resetDistrict();
        }
      });
    }
    
    $("#provincesModal").modal("hide");
  })
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
  $("#q_districts").val("");
  $("#show-districts").text(gon.all);
  $(".tooltip-district").attr("data-original-title", "");
  $(".district_code").val(null).trigger('change');
}

export {  onDistrictModalSave,
          onProvinceModalSave }
