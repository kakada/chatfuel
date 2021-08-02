import axios from "axios";

const Showcase = (() => {
  const init = () => {
    totalUsers();
    totalUsersAccessed();
    totalUniqueUsers();
    mostRequestServices();
  };

  const totalUsers = () => {
    axios
      .get("dashboard/total_users", { params: gon.params })
      .then((result) => {
        $(".showcase_total_users .data").text(result.data);
      })
      .catch((err) => console.log(err))
      .then(() => {
        $(".showcase_total_users .loading").hide();
      });
  };

  const totalUsersAccessed = () => {
    axios
      .get("dashboard/total_users_accessed", { params: gon.params })
      .then((result) => {
        $(".showcase_total_user_accessed .data").text(result.data);
      })
      .catch((err) => console.log(err))
      .then(() => {
        $(".showcase_total_user_accessed .loading").hide();
      });
  };

  const totalUniqueUsers = () => {
    axios
      .get("dashboard/total_unique_users", { params: gon.params })
      .then((result) => {
        $(".showcase_total_unique_users .data").text(result.data);
      })
      .catch((err) => console.log(err))
      .then(() => {
        $(".showcase_total_unique_users .loading").hide();
      });
  };

  const mostRequestServices = () => {
    $(".showcase_most_request_services .loading").hide();
  };

  return { init };
})();

export default Showcase;
