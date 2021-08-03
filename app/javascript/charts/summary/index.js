import { summaries } from "./summaries";

export const summary = {
  load: () => {
    summaries.forEach((summary) => summary.load());
  },
};
