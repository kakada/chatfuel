import { totalFeedbackByGender } from "./total_feedback_by_gender";
import { owsoFeedbackTrendByPeriod } from "./owso_feedback_trend_by_period";
import { overallRatingByOwso } from "./overall_rating_by_owso";
import { feedbackBySubCategories } from "./feedback_by_sub_categories";

export const citizenFeedback = {
  load: function () {
    totalFeedbackByGender.load();
    owsoFeedbackTrendByPeriod.load();
    overallRatingByOwso.load();
    feedbackBySubCategories.load();
  },
};
