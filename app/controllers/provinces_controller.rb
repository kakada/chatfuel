class ProvincesController < Pumi::ProvincesController
  skip_before_action :check_guisso_cookie

  def index
    render(json: Pumi::ResponseSerializer.new(pilot_provinces))
  end

  private

  def pilot_provinces
    Pumi::Province.pilots
  end
end
