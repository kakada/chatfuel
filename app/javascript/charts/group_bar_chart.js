import BarChart from "./bar_chart";
import { suggestedMax } from "../utils/bar_chart";

class GroupBarChart extends BarChart {
  childOptions = {
    legend: {
      display: true,
      labels: { boxWidth: 12 },
    },
    tooltips: {
      enabled: true,
      mode: "single",
      callbacks: {
        label: function (tooltipItems, data) {
          return (
            data.datasets[tooltipItems.datasetIndex].label +
            ": " +
            data.datasets[tooltipItems.datasetIndex].data[
              tooltipItems.index
            ].toLocaleString()
          );
        },
      },
    },
  };
  suggestedMax = (data) => suggestedMax(data, 1.2);
  dataset = () => this.format();
}

export default GroupBarChart;
