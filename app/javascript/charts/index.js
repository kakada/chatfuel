import { summary } from "./summary";
import { infoAccess } from "./owso-information-accessed";
import { citizenFeedback } from "./citizen-feedback";

OWSO.Charts = {
  getInstance: (target) => {
    let instance = $(target).data("instance");
    if (instance != undefined) return OWSO.Charts[instance];
    throw `Unknown instance ${instance}`;
  },
  Summary: {
    load: () => {
      summary.load();
    },
    markStatus: (status) => {
      $("#nav-summary-tab").data("status", status);
    },
  },
  Info: {
    load: () => {
      infoAccess.load();
    },
    markStatus: (status) => {
      $("#nav-accessed-tab").data("status", status);
    },
  },
  Feedback: {
    load: () => {
      citizenFeedback.load();
    },
    markStatus: (status) => {
      $("#nav-feedback-tab").data("status", status);
    },
  },
};
