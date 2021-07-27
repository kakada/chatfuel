require 'rails_helper'

RSpec.describe ProvincialUsages do
  let(:result) { {"01" => { visits: 1 }, "02" => { visits: 2 }} }

  let(:usage1) { build(:provincial_usage, result: result, pro_code: '01') }
  let(:usage2) { build(:provincial_usage, result: result, pro_code: '02') }
  let(:usages) { build(:provincial_usages) }

  before do
    usages.provincial_usages << usage1
    usages.provincial_usages << usage2
  end

  it "sorts ascending" do
    expect(usages.sort('visits_count', 'asc')).to eq [usage1, usage2]
  end

  it "sorts descending" do
    expect(usages.sort('visits_count', 'desc')).to eq [usage2, usage1]
  end

  it 'raises exception' do
    expect {
      usages.sort('no_method', 'desc')
    }.to raise_error Exception, /Available sortable attributes/
  end
end
