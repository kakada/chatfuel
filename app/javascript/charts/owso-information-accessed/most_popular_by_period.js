import axios from "axios";
import { mostPopularAccess } from "./most_tracked_periodic_chart";

export const mostPopularByPeriod = {
  load: () => {
    axios
      .get("dashboard/most_popular_by_period", { params: gon.params })
      .then((result) => {
        gon.mostTrackedPeriodic = result.data;
        mostPopularAccess.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
