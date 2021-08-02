import axios from "axios";

const Summary = (() => {
  const init = () => {
    totalUsers();
    totalUsersAccessed();
  };

  const totalUsers = () => {
    axios
      .get("dashboard/total_users")
      .then((result) => {
        $(".summary_total_users .data").text(result.data);
      })
      .catch((err) => console.log(err))
      .then(() => {
        $(".summary_total_users .loading").hide();
      });
  };

  const totalUsersAccessed = () => {
    axios
      .get("dashboard/total_users_accessed")
      .then((result) => {
        $(".summary_total_user_accessed .data").text(result.data);
      })
      .catch((err) => console.log(err))
      .then(() => {
        $(".summary_total_user_accessed .loading").hide();
      });
  };

  return { init };
})();

export default Summary;
