import axios from "axios";
import { userFeedback } from "../total_user_feedback_chart";

export const totalFeedbacks = {
  load: () => {
    axios
      .get("dashboard/total_feedbacks", { params: gon.params })
      .then((result) => {
        gon.totalUserFeedback = result.data;
        userFeedback.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
