import { requestService } from "../../services/requestService";
import { informationAccess } from "./access_info_chart";

export const informationAccessByPeriod = {
  load: function () {
    requestService
      .get("dashboard/information_access_by_period")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.accessInfo = data),
  render: () => {
    informationAccess.render();
  },
};
