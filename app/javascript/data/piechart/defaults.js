let mapLabel = (chart, label, i) => {
  let meta = chart.getDatasetMeta(0);
  let ds = chart.data.datasets[0];
  let arc = meta.data[i];
  let custom = arc && arc.custom || {};
  let getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
  let arcOpts = chart.options.elements.arc;
  let fill = custom.backgroundColor ? custom.backgroundColor : getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
  let stroke = custom.borderColor ? custom.borderColor : getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
  let bw = custom.borderWidth ? custom.borderWidth : getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
  let perc = parseFloat(ds.data[i] / chart.data.total*100).toFixed(2)

  return {
    text: label,
    fillStyle: fill,
    strokeStyle: stroke,
    lineWidth: bw,
    hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
    index: i
  }
}

export const isDisplay = function(context) {
  let dataset = context.dataset;
  let count = dataset.data.length;
  let value = dataset.data[context.dataIndex];
  return value > count * 1.5;
}

export const generateLabels = function(chart) {
  let data = chart.data
  return _.map(data.labels, mapLabel.bind(null, chart))
}

export const labels = {
  boxWidth: 12,
  usePointStyle: false,
  generateLabels: generateLabels
}
