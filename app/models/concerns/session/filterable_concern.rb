require 'csv'

module Session::FilterableConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(params = {})
      scope = all
      scope = scope.where(gender: params[:gender]) if params[:gender].present?
      scope = scope.where(session_type: params[:content_type]) if params[:content_type].present?
      scope = scope.where("province_id IN (?) ", ProvinceFilter.fetch(params[:province_id])) if params[:province_id].present?
      scope = scope.where("district_id IN (?) ", DistrictFilter.fetch(params[:district_id])) if params[:district_id].present?
      scope = scope.where(platform_name: params[:platform]) if params[:platform].present?
      scope = scope.where("DATE(sessions.engaged_at) BETWEEN ? AND ?", params[:start_date].to_date, params[:end_date].to_date) if params[:start_date].present? && params[:end_date].present?
      scope
    end
  end
end
