import stamp from "../images/stamp.png";

class BaseChart {
  plugins = [chartDataLabels];

  _suggestedMax = () => {
    let data = this.flatten(this.dataset());
    return this.suggestedMax(data);
  };

  flatten = (ds) => OWSO.Util.flattenDataset(ds.datasets);

  baseOptions = {
    legend: { display: false },
    layout: {
      padding: {
        top: 5,
        bottom: 5,
      },
    },
    plugins: {
      datalabels: {
        formatter: Math.round,
        backgroundColor: (context) => context.dataset.backgroundColor,
        borderColor: "white",
        borderRadius: 100,
        padding: 10,
        borderWidth: 2,
        color: "white",
        display: false,
        font: {
          family: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
          weight: "bold",
        },
      },
    },
  };

  watermarkOption = {
    watermark: {
      image: stamp,
      x: 0,
      y: 0,
      width: 128,
      height: 128,
      opacity: 0.05,
      alignX: "right",
      alignY: "bottom",
      position: "back",
    },
  };

  config = (opts = {}) => {
    let options =
      opts["watermark"] == false ? this.options() : this.optionsWithWatermark();

    return {
      type: this.type,
      plugins: this.plugins,
      options: options,
      data: this.dataset(),
    };
  };

  optionsWithWatermark = () => _.extend(this.options(), this.watermarkOption);

  render = (opts = {}) => {
    OWSO.Util.createOrUpdate(this.chartId, this.config(opts));
    if (!OWSO.Util.isEmpty(this.dataset().datasets)) this.enableLoading();
  };

  enableLoading = () => {
    $(`#${this.chartId}`)
      .closest(".card-body")
      .prev()
      .find(".period-filter")
      .attr("disabled", false);
  };
}

export default BaseChart;
