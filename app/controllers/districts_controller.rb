class DistrictsController < Pumi::DistrictsController
  def index
    render(json: Pumi::ResponseSerializer.new(owso_districts))
  end

  private
    def owso_districts
      district_codes_without_owsu.map do |id|
        Pumi::District.find_by_id(id)
      end
    end

    def district_codes
      Pumi::District.where(province_id: params[:province_id]).map &:id
    end

    def district_codes_without_owsu
      district_codes.reject do|code| 
        code.match? /#{VariableValue::OWSU_CODE_SUFFIX}$/
      end
    end
end
