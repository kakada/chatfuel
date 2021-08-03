import axios from "axios";

export const feedbackBySubCategories = {
  load: () => {
    axios
      .get("dashboard/feedback_by_sub_categories", { params: gon.params })
      .then((result) => {
        gon.feedbackSubCategories = result.data;
        OWSO.DashboardShow.loadProvinceSubCategories();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
