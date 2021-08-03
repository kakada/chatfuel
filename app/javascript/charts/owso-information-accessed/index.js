import { accessed } from "./accessed";

export const infoAccess = {
  load: function () {
    accessed.forEach((access) => access.load());
  },
};
