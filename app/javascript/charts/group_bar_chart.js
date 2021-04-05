import BarChart from "./bar_chart";
import { suggestedMax } from "../utils/bar_chart";

class GroupBarChart extends BarChart {
  childOptions =  { legend: {
                    display: true,
                    labels: { boxWidth: 12 }}}
  suggestedMax = (data) => suggestedMax(data, 1.5);
  dataset = () => this.format();
}

export default GroupBarChart;
