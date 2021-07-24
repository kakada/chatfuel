require("babel-polyfill");

window.chartDataLabels = require("chartjs-plugin-datalabels/dist/chartjs-plugin-datalabels");
window._ = require("underscore");

import { extractDonutDataset } from "../utils/donut_chart";
import { extractScatterDataset } from "../utils/line_chart/scatter_chart";
import { suggestedMax } from "../utils/bar_chart";
import { labels } from "../data/donutchart/defaults";
require("application/namespace");
require("application/util");

Chart.defaults.global.defaultFontSize = 16;
Chart.defaults.global.plugins.datalabels = {
  formatter: Math.round,
  backgroundColor: (context) => context.dataset.backgroundColor,
  borderColor: "white",
  borderRadius: 100,
  color: "white",
  display: false,
  font: {
    family: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
    weight: "bold",
  },
  borderWidth: 1,
  padding: function (context) {
    var index = context.dataIndex;
    var value = context.dataset.data[index];
    return value < 10 ? { left: 6, right: 6, top: 3, bottom: 3 } : 5;
  },
  display: true,
};

$(document).ready(function () {
  try {
    OWSO.Util.chartReg();

    totalVisitChart();
    totalFeedbackChart();
    feedbackSubCategories();
    mainServiceAccess();
  } catch (e) {
    $(".error-message").html(e.message);
  }
});

function mainServiceAccess() {
  try {
    let data = extractScatterDataset(gon.accessMainService);
    new Chart("chart_number_access_by_main_services", {
      type: "line",
      data: data,
      options: {
        legend: { display: false },
        layout: {
          padding: {
            right: 50,
          },
        },
        elements: {
          point: {
            pointStyle: "circle",
          },
        },
        scales: {
          xAxes: [
            {
              ticks: {
                autoSkip: false,
              },
            },
          ],
          yAxes: [
            {
              ticks: {
                suggestedMax: suggestedMax(
                  _.flatten(_.map(data.datasets, (ds) => ds.data))
                ),
              },
            },
          ],
        },
        animation: false,
        plugins: {
          datalabels: {
            anchor: "end",
            align: "end",
            rotation: 0,
            borderRadius: 0,
            textAlign: "center",
            backgroundColor: "#2F3559",
            color: "#FFF",
            padding: 3,
            font: { size: 10, weight: "normal" },
          },
        },
      },
    });
  } catch (error) {
    console.log(error.message);
  }
}

function feedbackSubCategories() {
  try {
    let { labels, dataset } = gon.feedbackSubCategories;
    let data = { labels, datasets: _.map(dataset, (el) => el) };

    new Chart("chart_feedback_by_sub_category", {
      type: "bar",
      data: data,
      options: {
        legend: {
          display: true,
          labels: { boxWidth: 12 },
        },
        plugins: {
          datalabels: {
            anchor: "end",
            align: "end",
            color: "#333",
            borderWidth: 0,
            padding: 0,
            backgroundColor: undefined,
            display: true,
            textAlign: "center",
            font: {
              weight: "normal",
            },
            formatter: function (value, context) {
              let { dataTitles } = context.dataset;
              if (dataTitles == undefined) return value;
              else
                return value > 0
                  ? dataTitles[context.dataIndex] + ":" + value
                  : gon.not_available;
            },
          },
        },
        cutoutPercentage: 80,
        animation: false,
        scales: {
          yAxes: [
            {
              ticks: {
                beginAtZero: true,
                suggestedMax: suggestedMax(
                  _.flatten(_.map(data.datasets, (ds) => ds.data))
                ),
              },
            },
          ],
          xAxes: [
            {
              maxBarThickness: 50,
              ticks: {
                beginAtZero: true,
                maxRotation: 0,
                minRotation: 0,
              },
            },
          ],
        },
      },
    });
  } catch (e) {
    console.log(e.message);
  }
}

function totalFeedbackChart() {
  try {
    let data = extractDonutDataset(gon.totalUserFeedback);

    new Chart("total_user_feedback", {
      data,
      type: "doughnut",
      options: {
        legend: {
          position: "left",
          labels,
        },
        cutoutPercentage: 80,
        animation: false, // not relate but should disable
      },
    });
  } catch (e) {
    console.log(e.message);
  }
}

function totalVisitChart() {
  try {
    let data = extractDonutDataset(gon.genderInfo);

    new Chart("chart_total_user_visit", {
      data,
      type: "doughnut",
      plugins: [chartDataLabels],
      options: {
        legend: {
          position: "left",
          labels,
        },
        cutoutPercentage: 80,
        animation: false, // not relate but should disable
      },
    });
  } catch (e) {
    console.log(e.message);
  }
}
