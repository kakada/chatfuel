// import { informationAccess } from "./access_info_chart";
// import { mainServiceAccess } from "./access_main_service_chart";
// import { mostPopularAccess } from "./most_tracked_periodic_chart";
// import { ticketTrackingAccess } from "./ticket_tracking_by_genders_chart";
import { informationAccessByGender } from "./information_access_by_gender";

export const infoAccess = {
  // render: function () {
  // informationAccess.render()
  // mainServiceAccess.render()
  // mostPopularAccess.render()
  // ticketTrackingAccess.render()
  // },
  load: function () {
    informationAccessByGender.load();
  },
};
