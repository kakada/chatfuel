import { feedbacks } from "./feedbacks";

export const citizenFeedback = {
  load: function () {
    feedbacks.forEach((feedback) => feedback.load());
  },
};
// import { genderFeedback } from './gender_feedback_chart'

// export const citizenFeedback = {
//   render: function() {
//     genderFeedback.render()
//   }
// }
