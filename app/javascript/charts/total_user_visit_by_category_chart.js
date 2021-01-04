import { sum } from '../utils/array'
import { generateLabels, isDisplay } from '../data/piechart/defaults'

export const totalUserVisitByCategory = () => {
  let type = 'pie', 
      plugins = [chartDataLabels];

  let { colors, dataset } = gon.totalUserVisitByCategory;
  let [categoryLabels, values] = [_.keys(dataset), _.values(dataset)];

  let data = {
    labels: categoryLabels,
    total: sum(values),
    datasets: [
      {
        backgroundColor: colors,
        data: values,
      }
    ]
  };

  let options = {
    legend: {
      position: "left",
      labels: {
        boxWidth: 12,
        generateLabels: generateLabels
      }
    },
    plugins: {
      datalabels: {
        backgroundColor: function(context) {
          return context.dataset.backgroundColor;
        },
        borderColor: 'white',
        borderRadius: 100,
        padding: 10,
        borderWidth: 2,
        color: 'white',
        display: false,
        font: {
          family: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
          weight: 'bold'
        },
        formatter: Math.round
      }
    }
  };

  console.log(data)
  new Chart('chart_total_user_visit', { type, plugins, data, options });
}
