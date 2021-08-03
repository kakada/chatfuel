import axios from "axios";
import { trendingFeedback } from "./feedback_trend_chart";

export const owsoFeedbackTrendByPeriod = {
  load: () => {
    axios
      .get("dashboard/owso_feedback_trend_by_period", { params: gon.params })
      .then((result) => {
        gon.feedbackTrend = result.data;
        trendingFeedback.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
