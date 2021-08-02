import axios from "axios";

const Summary = (() => {
  const init = () => {
    totalUser();
  };

  const totalUser = () => {
    axios
      .get("dashboard/total_user")
      .then((result) => {
        $(".summary_total_user .data").text(result.data);
      })
      .catch((err) => console.log(err))
      .then(() => {
        $(".summary_total_user .loading").hide();
      });
  };

  return { init };
})();

export default Summary;
