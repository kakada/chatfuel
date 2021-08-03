import { requestService } from "../services/requestService";

export const totalUsersAccessed = () => {
  let $totalUsersAccessed = $(".showcase_total_user_accessed");
  requestService
    .get("dashboard/total_users_accessed")
    .then((r) => $totalUsersAccessed.find(".data").text(r.data))
    .catch((err) => console.log(err))
    .then(() => $totalUsersAccessed.find(".loading").hide());
};
