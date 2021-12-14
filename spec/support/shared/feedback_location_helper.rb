RSpec.shared_context "feedback location helper" do
  let(:feedback_unit) { build(:variable, :feedback_unit) }
  let(:owso) { build(:variable_value, variable: feedback_unit, raw_value: 'owso') }
  let(:feedback_unit_step) { build(:step_value, variable: feedback_unit, variable_value: owso) }
  let(:feedback_province) { build(:variable, :feedback_province) }
  let(:battambang) { build(:variable_value, variable: feedback_province, raw_value: "02") }
  let(:feedback_province_step) { build(:step_value, variable: feedback_province, variable_value: battambang) }
  let(:feedback_district) { build(:variable, :feedback_district) }
  let(:kamrieng) { build(:variable_value, variable: feedback_district, raw_value: "0212") }
  let(:feedback_district_step) { build(:step_value, variable: feedback_district, variable_value: kamrieng) }
end

RSpec.configure do |config|
  config.include_context "feedback location helper"
end
