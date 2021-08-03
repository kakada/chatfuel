import { totalVisits } from "./total_visits";
import { totalFeedbacks } from "./total_feedbacks";

export const summary = {
  load: () => {
    totalVisits.load();
    totalFeedbacks.load();
  },
};
