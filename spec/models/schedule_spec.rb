require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:schedule) { build(:schedule, day: '1', time: '01:01') }

  it { is_expected.to validate_presence_of(:name) }

  it '#cron' do
    expect(schedule.cron).to eq '01 01 1 * *'
  end

  it '#cron_description' do
    expect(schedule.cron_description).to eq 'At 1:01 AM, on day 1 of the month'
  end

  it 'removes a cron job if schedule is destroyed' do
    expect(schedule).to receive(:remove_schedule)
    schedule.destroy
  end

  describe 'callbacks' do
    context 'when :enabled is True' do
      it 'sets a cron job after save' do
        schedule.enabled = true
        expect(schedule).to receive(:set_schedule)
        schedule.save
      end
    end

    context 'when :enabled is False' do
      it 'removes a cron job' do
        schedule.enabled = false
        expect(schedule).to receive(:remove_schedule)
        schedule.save
      end
    end
  end
end
