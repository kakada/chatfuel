import { requestService } from "../../services/requestService";
import { mostPopularAccess } from "./most_tracked_periodic_chart";

export const mostPopularByPeriod = {
  load: function () {
    requestService
      .get("dashboard/most_popular_by_period")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.mostTrackedPeriodic = data),
  render: () => {
    mostPopularAccess.render();
  },
};
