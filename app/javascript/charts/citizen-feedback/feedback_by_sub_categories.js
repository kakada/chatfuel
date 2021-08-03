import { requestService } from "../../services/requestService";

export const feedbackBySubCategories = {
  load: function () {
    requestService
      .get("dashboard/feedback_by_sub_categories")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.feedbackSubCategories = data),
  render: () => {
    OWSO.DashboardShow.loadProvinceSubCategories();
  },
};
