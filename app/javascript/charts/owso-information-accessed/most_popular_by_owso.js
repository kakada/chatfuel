import { requestService } from "../../services/requestService";
import { mainServiceAccess } from "./access_main_service_chart";

export const mostPopularByOwso = {
  load: function () {
    requestService
      .get("dashboard/most_popular_by_owso")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.accessMainService = data),
  render: () => {
    mainServiceAccess.render();
  },
};
