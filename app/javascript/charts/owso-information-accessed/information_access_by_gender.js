import axios from "axios";
import { userGender } from "../total_user_by_gender_chart";

export const informationAccessByGender = {
  load: () => {
    axios
      .get("dashboard/information_access_by_genders", { params: gon.params })
      .then((result) => {
        gon.totalUserByGender = result.data;
        userGender.render();
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
