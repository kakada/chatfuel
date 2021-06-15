export const extract = (ds) => {
  let { colors, dataset } = ds;
  let [labels, values] = [_.keys(dataset), _.values(dataset)];

  return { colors, labels, values };
};
