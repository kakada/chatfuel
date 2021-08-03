class Dashboard::FeedbackBySubCategoriesController < DashboardController
  def index
    render json: @query.feedback_sub_categories
  end
end
