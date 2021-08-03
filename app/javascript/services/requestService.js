import axios from "axios";

export const requestService = {
  get: (path) => {
    return axios.get(path, { params: gon.params });
  },
};
