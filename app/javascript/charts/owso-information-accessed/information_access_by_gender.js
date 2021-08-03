import { requestService } from "../../services/requestService";
import { userGender } from "../total_user_by_gender_chart";

export const informationAccessByGender = {
  load: function () {
    requestService
      .get("dashboard/information_access_by_genders")
      .then((r) => this.setup(r.data))
      .then(() => this.render())
      .catch((err) => console.log(err));
  },
  setup: (data) => (gon.totalUserByGender = data),
  render: () => {
    userGender.render();
  },
};
