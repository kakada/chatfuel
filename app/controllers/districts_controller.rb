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
      all_district_codes = Pumi::District.where(province_id: params[:province_id]).map &:id
      all_district_codes - pilot_other_districts
    end

    def pilot_other_districts
      Pumi::Province.pilots.map do |province|
        "#{province.id}#{VariableValue::OTHER_CODE_SUFFIX}"
      end
    end

    def district_codes_without_owsu
      district_codes.reject do|code| 
        code.match? /#{VariableValue::OWSU_CODE_SUFFIX}$/
      end
    end
end
