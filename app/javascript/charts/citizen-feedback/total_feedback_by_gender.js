import axios from "axios";
import { genderFeedback } from "./gender_feedback_chart";

export const totalFeedbackByGender = {
  load: () => {
    axios
      .get("dashboard/total_feedback_by_gender", { params: gon.params })
      .then((result) => {
        gon.genderInfo = result.data;
        genderFeedback.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
