import { infoAccess } from './owso-information-accessed';
import { citizenFeedback } from './citizen-feedback';
import { dashboard } from './private-dashboard';

export const renderChart = function () {
  OWSO.Util.chartReg();

  infoAccess.render();
  citizenFeedback.render();
  dashboard.render();
}