require 'rails_helper'

RSpec.describe ProvincialUsage do
  let(:result) { {"08" => { visits: 1, uniques: 2, service_delivered: 3, most_request_services: 4 }} }
  let(:provincial_usage) { build(:provincial_usage, result: result, pro_code: '08') }

  subject { ProvincialUsage }

  it "#province_name" do
    expect(provincial_usage.province_name).to eq 'Kandal Province'
  end

  it "#visits_count" do
    expect(provincial_usage.visits_count).to eq 1
  end

  it '#unique_users_count' do
    expect(provincial_usage.unique_users_count).to eq 2
  end

  it '#service_delivered_count' do
    expect(provincial_usage.service_delivered_count).to eq 3
  end

  it '#most_request_service' do
    expect(provincial_usage.most_request_service).to eq 4
  end

  it '.fetch_and_transform' do
    expect(subject).to receive(:fetch)
    expect(subject).to receive(:transform)
    subject.fetch_and_transform({})
  end
end
