import LineChart from "./line_chart";

class ScatterChart extends LineChart {
  ancestor = new LineChart();

  options = () => {
    return {
      ...this.ancestor.options(),
      legend: { display: false },
      layout: {
        padding: {
          right: 50,
        },
      },
      elements: {
        point: {
          pointStyle: "circle",
        },
      },
      scales: {
        xAxes: [
          {
            ticks: {
              autoSkip: false,
            },
          },
        ],
        yAxes: [
          {
            ticks: {
              suggestedMax: this._suggestedMax(),
            },
          },
        ],
      },
      plugins: {
        datalabels: {
          anchor: "end",
          align: "end",
          rotation: 0,
          textAlign: "center",
          backgroundColor: "#2F3559",
          color: "#FFF",
          font: { size: 10 },
          formatter: function (value, context) {
            return value.toLocaleString();
          },
        },
      },
    };
  };
}

export default ScatterChart;
