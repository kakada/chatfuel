import axios from "axios";
import { userVisit } from "../total_user_visit_by_category_chart";

export const totalVisits = {
  load: () => {
    axios
      .get("dashboard/total_visits", { params: gon.params })
      .then((result) => {
        gon.totalUserVisitByCategory = result.data;
        userVisit.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
