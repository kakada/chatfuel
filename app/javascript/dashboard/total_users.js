import { requestService } from "../services/requestService";

export const totalUsers = () => {
  let $totalUsers = $(".showcase_total_users");
  requestService
    .get("dashboard/total_users")
    .then((r) => $totalUsers.find(".data").text(r.data))
    .catch((err) => console.log(err))
    .then(() => $totalUsers.find(".loading").hide());
};
