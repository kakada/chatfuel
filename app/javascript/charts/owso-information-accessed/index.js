// import { informationAccess } from "./access_info_chart";
// import { mainServiceAccess } from "./access_main_service_chart";
// import { mostPopularAccess } from "./most_tracked_periodic_chart";
// import { ticketTrackingAccess } from "./ticket_tracking_by_genders_chart";
import { mostRequestedServiceByOwso } from "./most_requested_service_by_owso";
import { informationAccessByGender } from "./information_access_by_gender";
import { informationAccessByPeriod } from "./information_access_by_period";

import { mostPopularByOwso } from "./most_popular_by_owso";
import { mostPopularByPeriod } from "./most_popular_by_period";
import { userAccess } from "./user_access";
import { tracking } from "./ticket_tracking";
import { ticketTrackingByGender } from "./ticket_tracking_by_gender";

export const infoAccess = {
  // render: function () {
  // informationAccess.render()
  // mainServiceAccess.render()
  // mostPopularAccess.render()
  // ticketTrackingAccess.render()
  // },
  load: function () {
    mostRequestedServiceByOwso.load();
    informationAccessByGender.load();
    informationAccessByPeriod.load();
    mostPopularByOwso.load();
    mostPopularByPeriod.load();
    userAccess.load();
    tracking.load();
    ticketTrackingByGender.load();
  },
};
