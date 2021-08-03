import { mostRequestedServiceByOwso } from "./most_requested_service_by_owso";
import { informationAccessByGender } from "./information_access_by_gender";
import { informationAccessByPeriod } from "./information_access_by_period";
import { mostPopularByOwso } from "./most_popular_by_owso";
import { mostPopularByPeriod } from "./most_popular_by_period";
import { userAccess } from "./user_access";
import { tracking } from "./ticket_tracking";
import { ticketTrackingByGender } from "./ticket_tracking_by_gender";

export const accessed = [
  mostRequestedServiceByOwso,
  informationAccessByGender,
  informationAccessByPeriod,
  mostPopularByOwso,
  mostPopularByPeriod,
  userAccess,
  tracking,
  ticketTrackingByGender,
];
