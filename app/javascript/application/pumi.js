window.pumi;

pumi = {
  dataAttributeTag: function(attribute, selector) {
    var tag;
    tag = "pumi-select-" + attribute;
    return tag = !!selector ? "[data-" + tag + "]" : tag;
  },
  setDataAttribute: function(element, attribute, value) {
    return element.data(pumi.dataAttributeTag(attribute), value);
  },
  getDataAttribute: function(element, attribute, value) {
    return element.data(pumi.dataAttributeTag(attribute));
  },
  removeDataAttribute: function(element, attribute) {
    return element.removeData(pumi.dataAttributeTag(attribute));
  },
  toggleEnableSelect: function(select, enable) {
    var disabledClass, wrapperTarget;
    wrapperTarget = select.closest(pumi.getDataAttribute(select, 'disabled-target'));
    disabledClass = pumi.getDataAttribute(select, 'disabled-class');
    if (!!enable) {
      wrapperTarget.removeClass(disabledClass);
      return select.removeAttr("disabled");
    } else {
      wrapperTarget.addClass(disabledClass);
      return select.attr("disabled", "disabled");
    }
  },
  selectPopulateOnLoad: function() {
    return $(pumi.dataAttributeTag('populate-on-load', true));
  },
  selectTargets: function() {
    return $(pumi.dataAttributeTag('id', true));
  },
  selectHasTarget: function() {
    return $(pumi.dataAttributeTag('target', true));
  },
  selectTarget: function(id) {
    return $(pumi.dataAttributeTag("id=" + id, true));
  },
  selectHasHiddenValue: (function(_this) {
    return function() {
      return $(pumi.dataAttributeTag('has-hidden-value', true));
    };
  })(this),
  setupOnLoad: function() {
    pumi.selectPopulateOnLoad().each(function() {
      return pumi.populateFromAjax($(this));
    });
    return pumi.selectHasHiddenValue().each(function() {
      var select;
      select = $(this);
      return pumi.setDataAttribute(select, 'default-value', $($.find("[name='" + (select.attr('name')) + "']")).val());
    });
  },
  populateFromAjax: function(select, filterValue) {
    var collectionUrl, filterInterpolationKey, labelMethod, valueMethod;
    collectionUrl = pumi.getDataAttribute(select, 'collection-url');
    if (!!collectionUrl) {
      filterInterpolationKey = pumi.getDataAttribute(select, 'collection-url-filter-interpolation-key');
      labelMethod = pumi.getDataAttribute(select, 'collection-label-method');
      valueMethod = pumi.getDataAttribute(select, 'collection-value-method');
      return $.getJSON(collectionUrl.replace(filterInterpolationKey, filterValue), function(data) {
        var defaultValue;
        $.each(data, function(index, item) {
          return select.append($('<option>').text(item[labelMethod]).val(item[valueMethod]));
        });
        defaultValue = pumi.getDataAttribute(select, 'default-value');
        if (!!defaultValue) {
          select.val(defaultValue.split(","));
          pumi.removeDataAttribute(select, 'default-value');
          return select.trigger("change");
        }
      });
    }
  },
  setupTargets: function(selects) {
    return selects.each(function() {
      var options, select;
      select = $(this);
      options = [];
      select.find('option').each(function() {
        return options.push({
          value: this.value,
          text: this.text
        });
      });
      pumi.setDataAttribute(select, 'options', options);
      return pumi.toggleEnableSelect(select, false);
    });
  },
  filterSelectByValue: function(select, filterValue) {
    var staticPumiOptions;
    staticPumiOptions = pumi.getDataAttribute(select, 'options');
    select.empty();
    pumi.toggleEnableSelect(select, !!filterValue);
    select.trigger("change");
    $.each(staticPumiOptions, function(i) {
      var pumiOption;
      pumiOption = staticPumiOptions[i];
      if( filterValue.match(/^00/) ) return;
      
      if (!pumiOption.value || pumiOption.value.match(RegExp("^" + filterValue))) {
        return select.append($('<option>').text(pumiOption.text).val(pumiOption.value));
      }
    });
    if (!!filterValue) {
      return pumi.populateFromAjax(select, filterValue);
    }
  },
  setup: function() {
    pumi.setupOnLoad();
    pumi.setupTargets(pumi.selectTargets());
    return pumi.selectHasTarget().change(function() {
      return pumi.filterSelectByValue(pumi.selectTarget(pumi.getDataAttribute($(this), 'target')), this.value);
    });
  }
};

$(document).on('turbolinks:load', function() {
  return pumi.setup();
});
