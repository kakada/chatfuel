class ProvincesController < Pumi::ProvincesController
  skip_before_action :check_guisso_cookie

  def index
    render(json: Pumi::ResponseSerializer.new(pilot_provinces))
  end

  private

  def pilot_provinces
    Setting.pilot_province_codes.map do |id|
      Pumi::Province.find_by_id(id)
    end
  end
end
