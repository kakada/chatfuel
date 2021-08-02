import { totalVisits } from "./total_visits";
import { totalFeedbacks } from "./total_feedbacks";

// import { userGender } from "../total_user_by_gender_chart";
// import { ticketTracking } from "../ticket_tracking_chart";
// import { overview } from "../overview_chart";

export const summary = {
  load: () => {
    totalVisits.load();
    totalFeedbacks.load();
  },

  // render: function () {
  // userVisit.render({ watermark: false });
  // userFeedback.render({ watermark: false });
  // userGender.render({watermark: false});
  // ticketTracking.render({watermark: false});
  // overview.render({watermark: false});
  // },
};
