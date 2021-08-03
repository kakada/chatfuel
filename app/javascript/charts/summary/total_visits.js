import { requestService } from "../../services/requestService";
import { userVisit } from "../total_user_visit_by_category_chart";

export const totalVisits = {
  load: function () {
    requestService
      .get("dashboard/total_visits")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.totalUserVisitByCategory = data),
  render: () => {
    userVisit.render();
  },
};
