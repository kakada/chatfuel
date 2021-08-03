import { requestService } from "../../services/requestService";
import { trendingFeedback } from "./feedback_trend_chart";

export const owsoFeedbackTrendByPeriod = {
  load: function () {
    requestService
      .get("dashboard/owso_feedback_trend_by_period")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.feedbackTrend = data),
  render: () => {
    trendingFeedback.render();
  },
};
