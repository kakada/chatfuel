require "rails_helper"

RSpec.describe HomeController do
  describe "routes" do
    it { should route(:get, "/home").to(action: :show) }
  end
end
