import axios from "axios";
import { mainServiceAccess } from "./access_main_service_chart";

export const mostPopularByOwso = {
  load: () => {
    axios
      .get("dashboard/most_popular_by_owso", { params: gon.params })
      .then((result) => {
        gon.accessMainService = result.data;
        mainServiceAccess.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
