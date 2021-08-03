import { requestService } from "../../services/requestService";
import { genderFeedback } from "./gender_feedback_chart";

export const totalFeedbackByGender = {
  load: function () {
    requestService
      .get("dashboard/total_feedback_by_gender")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.genderInfo = data),
  render: () => {
    genderFeedback.render();
  },
};
