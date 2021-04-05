// ow4c charts
import { userVisit } from '../total_user_visit_by_category_chart';
import { userGender } from '../total_user_by_gender_chart';
import { userFeedback } from '../total_user_feedback_chart';

export const dashboard = {
  instances: [
    userVisit,
    userGender,
    userFeedback,
  ],
  render: function() {
    _.each(this.instances, instance => instance.render());
  }
}
