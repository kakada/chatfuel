import { requestService } from "../../services/requestService";

export const overallRatingByOwso = {
  load: function () {
    requestService
      .get("dashboard/overall_rating_by_owso")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.overallRating = data),
  render: () => {
    OWSO.DashboardShow.loadProvinceOverallRating();
  },
};
