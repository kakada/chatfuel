import { requestService } from "../../services/requestService";
import { ticketTrackingAccess } from "./ticket_tracking_by_genders_chart";

export const ticketTrackingByGender = {
  load: function () {
    requestService
      .get("dashboard/ticket_tracking_by_gender")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.ticketTrackingByGenders = data),
  render: () => {
    ticketTrackingAccess.render();
  },
};
