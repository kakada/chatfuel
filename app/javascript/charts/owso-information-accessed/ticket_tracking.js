import axios from "axios";
import { ticketTracking } from "../../charts/ticket_tracking_chart";

export const tracking = {
  load: () => {
    axios
      .get("dashboard/ticket_tracking", { params: gon.params })
      .then((result) => {
        gon.ticketTracking = result.data;
        ticketTracking.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
