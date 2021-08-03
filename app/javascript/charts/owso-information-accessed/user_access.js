import axios from "axios";
import { overview } from "../../charts/overview_chart";

export const userAccess = {
  load: () => {
    axios
      .get("dashboard/user_access", { params: gon.params })
      .then((result) => {
        gon.overview = result.data;
        overview.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
