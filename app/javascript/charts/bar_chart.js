import BaseChart from "./base_chart";

class BarChart extends BaseChart {
  type = "bar";

  dataFormat = () => ({
    maxBarThickness: 36,
    minBarLength: 2,
  });

  options() {
    let { plugins } = this.baseOptions;

    return Object.assign({}, this.baseOptions, this.childOptions, {
      plugins: {
        datalabels: {
          ...plugins.datalabels,
          anchor: "end",
          align: "end",
          color: "#333",
          borderWidth: 0,
          padding: 0,
          backgroundColor: undefined,
          display: true,
          textAlign: "center",
          font: {
            weight: "normal",
          },
          formatter: function (value, context) {
            let { dataTitles } = context.dataset;
            if (dataTitles == undefined) return value && value.toLocaleString();
            else
              return value > 0
                ? dataTitles[context.dataIndex] + ":" + value.toLocaleString()
                : gon.not_available;
          },
        },
      },
      cutoutPercentage: 80,
      scales: {
        yAxes: [
          {
            ticks: {
              beginAtZero: true,
              suggestedMax: this._suggestedMax(),
            },
          },
        ],
        xAxes: [
          {
            maxBarThickness: 50,
            ticks: {
              beginAtZero: true,
              suggestedMax: this._suggestedMax(),
              maxRotation: 0,
              minRotation: 0,
              ...this.ticksOptions,
            },
          },
        ],
      },
    });
  }
}

export default BarChart;
