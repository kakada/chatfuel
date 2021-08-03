import axios from "axios";

export const overallRatingByOwso = {
  load: () => {
    axios
      .get("dashboard/overall_rating_by_owso", { params: gon.params })
      .then((result) => {
        gon.overallRating = result.data;
        OWSO.DashboardShow.loadProvinceOverallRating();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
