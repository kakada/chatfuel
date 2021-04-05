class DistrictsController < Pumi::DistrictsController
  include Filterable
  skip_before_action :check_guisso_cookie
  before_action :set_query, only: [:index]

  def index
    render(json: Pumi::ResponseSerializer.new(pilot_districts))
  end

  private
    def pilot_districts
      pilot_district_codes.map do |id|
        Pumi::District.find_by_id(id)
      end
    end

    def district_codes
      Pumi::District.where(province_id: params[:province_id]).map(&:id)
    end

    def pilot_district_codes
      district_codes & @query.district_codes_without_other
    end

    def set_query
      @query = DashboardQuery.new(filter_options)
    end
end
