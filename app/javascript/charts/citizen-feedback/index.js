import { genderFeedback } from "./gender_feedback_chart";
import { trendingFeedback } from "./feedback_trend_chart";

import { totalFeedbackByGender } from "./total_feedback_by_gender";
import { owsoFeedbackTrendByPeriod } from "./owso_feedback_trend_by_period";
import { overallRatingByOwso } from "./overall_rating_by_owso";
import { feedbackBySubCategories } from "./feedback_by_sub_categories";

export const citizenFeedback = {
  // render: function () {
  //   genderFeedback.render();
  //   trendingFeedback.render();
  // },
  load: function () {
    totalFeedbackByGender.load();
    owsoFeedbackTrendByPeriod.load();
    overallRatingByOwso.load();
    feedbackBySubCategories.load();
  },
};
