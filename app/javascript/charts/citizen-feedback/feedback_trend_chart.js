import GroupBarChart from "../group_bar_chart";

class TrendingFeedbackChart extends GroupBarChart {
  chartId = "chart_owso_feedback_trend";
  rotateOption = {
    autoSkip: false,
    maxRotation: 45,
    minRotation: 45,
  };

  format = () => {
    let { labels, dataset } = this.ds;
    return { labels, datasets: _.map(dataset, (el) => el) };
  };
}

export const trendingFeedback = new TrendingFeedbackChart();
