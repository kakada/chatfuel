import stamp from "../images/stamp.png";

class BaseChart {
  plugins = [chartDataLabels];
  baseOptions = {
    layout: {
      padding: {
        bottom: 15,
        top: 15,
      }
    },
    legend: { display: false },
    plugins: {
      datalabels: {
        formatter: Math.round,
        backgroundColor: (context) => context.dataset.backgroundColor,
        borderColor: 'white',
        borderRadius: 100,
        padding: 10,
        borderWidth: 2,
        color: 'white',
        display: false,
        font: {
          family: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
          weight: 'bold'
        },
      }
    },
  }

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
    }
  }

  config = (opts = {}) => {
    let options = (opts['watermark'] == false) ? this.options : this.optionsWithWatermark();

    return {
      type: this.type,
      plugins: this.plugins,
      options: options,
      data: this.dataset()
    }
  };

  optionsWithWatermark = () => _.extend(this.options, this.watermarkOption);

  render = (opts = {}) => {
    new Chart(this.chartId, this.config(opts));
  };
}

export default BaseChart;
