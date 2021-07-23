require 'rails_helper'

RSpec.describe DoReportSendPdfJob, type: :job do
  include ActiveJob::TestHelper

  subject { DoReportSendPdfJob }

  it { is_expected.to be_processed_in :default }

  it "enqueues a job" do
    expect do
      subject.perform_later
    end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it "enqueues on default queue" do
    expect do
      subject.perform_later
    end.to have_enqueued_job(described_class).on_queue "default"
  end
end
