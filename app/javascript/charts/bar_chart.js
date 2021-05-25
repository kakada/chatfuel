import BaseChart from "./base_chart";

class BarChart extends BaseChart {
  type = "bar";

  dataFormat = () => ({
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
            if (dataTitles == undefined) return value;
            else
              return value > 0
                ? dataTitles[context.dataIndex] + ":" + value
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
            ticks: {
              beginAtZero: true,
              suggestedMax: this._suggestedMax(),
              maxRotation: 0,
              minRotation: 0,
            },
          },
        ],
      },
    });
  }
}

export default BarChart;
