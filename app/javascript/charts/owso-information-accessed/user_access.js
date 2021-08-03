import { requestService } from "../../services/requestService";
import { overview } from "../../charts/overview_chart";

export const userAccess = {
  load: function () {
    requestService
      .get("dashboard/user_access")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.overview = data),
  render: () => {
    overview.render();
  },
};
