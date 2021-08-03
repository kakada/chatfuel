import { feedbacks } from "./feedbacks";

export const citizenFeedback = {
  load: function () {
    feedbacks.forEach((feedback) => feedback.load());
  },
};
