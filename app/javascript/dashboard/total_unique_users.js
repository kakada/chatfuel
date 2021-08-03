import { requestService } from "../services/requestService";

export const totalUniqueUsers = () => {
  let $totalUniqueUsers = $(".showcase_total_unique_users");
  requestService
    .get("dashboard/total_unique_users")
    .then((r) => $totalUniqueUsers.find(".data").text(r.data))
    .catch((err) => console.log(err))
    .then(() => $totalUniqueUsers.find(".loading").hide());
};
