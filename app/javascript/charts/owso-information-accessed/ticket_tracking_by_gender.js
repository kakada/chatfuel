import axios from "axios";
import { ticketTrackingAccess } from "./ticket_tracking_by_genders_chart";

export const ticketTrackingByGender = {
  load: () => {
    axios
      .get("dashboard/ticket_tracking_by_gender", { params: gon.params })
      .then((result) => {
        gon.ticketTrackingByGenders = result.data;
        ticketTrackingAccess.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
