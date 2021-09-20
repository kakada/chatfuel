module StepValue::FilterableConcern
  extend ActiveSupport::Concern

  included do
    def self.filter(params={}, scope = all)
      scope = scope.where(session_id: Session.where(gender: params[:gender])) if params[:gender].present?
      scope = scope.where(session_id: Session.where(session_type: params[:content_type])) if params[:content_type].present?
      scope = scope.where(session_id: Session.where("province_id IN (?) ", ProvinceFilter.fetch(params[:province_id]))) if params[:province_id].present?
      scope = scope.where(session_id: Session.where("district_id IN (?) ", DistrictFilter.fetch(params[:district_id]))) if params[:district_id].present?
      scope = scope.where(session_id: Session.where(platform_name: params[:platform])) if params[:platform].present?
      scope = scope.where(variable_id: params[:variable_id]) if params[:variable_id].present?
      scope = scope.where(variable_value: params[:variable_value]) if params[:variable_value].present?
      scope = scope.where("DATE(step_values.created_at) BETWEEN ? AND ?", params[:start_date].to_date, params[:end_date].to_date) if params[:start_date].present? && params[:end_date].present?

      scope
    end
  end

end
