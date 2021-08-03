import { requestService } from "../../services/requestService";
import { ticketTracking } from "../../charts/ticket_tracking_chart";

export const tracking = {
  load: function () {
    requestService
      .get("dashboard/ticket_tracking")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.ticketTracking = data),
  render: () => {
    ticketTracking.render();
  },
};
