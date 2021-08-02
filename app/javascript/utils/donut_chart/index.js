import { extract } from "../index";

export const extractDonutDataset = (ds) => {
  let { labels, colors, values } = extract(ds);

  return {
    labels: labels,
    datasets: [{ backgroundColor: colors, data: values }],
  };
};
