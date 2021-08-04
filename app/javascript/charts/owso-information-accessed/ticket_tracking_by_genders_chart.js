import DonutChart from "../donut_chart";
import { extractDonutDataset } from "../../utils/donut_chart";

class TicketTrackingAccessChart extends DonutChart {
  chartId = "chart_ticket_tracking_by_gender";

  suggestedMax = (data) => suggestedMax(data, 1.5);
  dataset = () => extractDonutDataset(gon.ticketTrackingByGenders);
}

export const ticketTrackingAccess = new TicketTrackingAccessChart();
