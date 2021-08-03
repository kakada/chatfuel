import axios from "axios";

export const mostRequestedServiceByOwso = {
  load: () => {
    axios
      .get("dashboard/most_requested_service_by_owso", { params: gon.params })
      .then((result) => {
        gon.mostRequest = result.data;
        OWSO.DashboardShow.loadProvinceMostRequest();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
