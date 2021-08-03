import axios from "axios";
import { informationAccess } from "./access_info_chart";

export const informationAccessByPeriod = {
  load: () => {
    axios
      .get("dashboard/information_access_by_period", { params: gon.params })
      .then((result) => {
        gon.accessInfo = result.data;
        informationAccess.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
