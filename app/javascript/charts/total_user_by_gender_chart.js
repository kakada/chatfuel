import DonutChart from './donut_chart'
import { extractDonutDataset } from '../utils'

class UserGender extends DonutChart {
  chartId = "total_user_gender";
  dataset = () => extractDonutDataset(gon.totalUserByGender);
}

export const userGender = new UserGender();
