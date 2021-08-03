import { requestService } from "../../services/requestService";
import { userFeedback } from "../total_user_feedback_chart";

export const totalFeedbacks = {
  load: function () {
    requestService
      .get("dashboard/total_feedbacks")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.totalUserFeedback = data),
  render: () => {
    userFeedback.render();
  },
};
