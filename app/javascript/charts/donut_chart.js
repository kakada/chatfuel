import BaseChart from "./base_chart";
import { labels } from "../data/donutchart/defaults";

class DonutChart extends BaseChart {
  type = "doughnut";

  options() {
    let { plugins } = this.baseOptions;

    return Object.assign({}, this.baseOptions, {
      legend: {
        position: "left",
        labels: labels,
      },
      plugins: {
        datalabels: {
          ...plugins.datalabels,
          borderWidth: 1,
          padding: function (context) {
            var index = context.dataIndex;
            var value = context.dataset.data[index];
            return value < 10 ? { left: 6, right: 6, top: 3, bottom: 3 } : 5;
          },
          display: true,
        },
      },
      cutoutPercentage: 80,
    });
  }
}

export default DonutChart;
