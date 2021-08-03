import { requestService } from "../../services/requestService";

export const mostRequestedServiceByOwso = {
  load: function () {
    requestService
      .get("dashboard/most_requested_service_by_owso")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.mostRequest = data),
  render: () => {
    OWSO.DashboardShow.loadProvinceMostRequest();
  },
};
