require "rails_helper"

RSpec.describe HomeController do
  describe "routes" do
    it { should route(:get, "/").to(controller: :welcomes, action: :index) }
  end
end
