require "rails_helper"

RSpec.describe Channels::MessengerChannel do
  let(:ticket) { build(:ticket) }
  let(:message) { build(:message, :text) }

  it "calls #send_message one time" do
    expect(subject).to receive(:send_message).with(ticket).once
    subject.send_message(ticket)
  end

  describe "incomplete ticket" do
    let!(:template) { create(:template, :incomplete) }
    let(:ticket) { build(:ticket, :incomplete) }

    it "#params" do
      allow(ticket).to receive(:message).and_return(message)
      response = {  message: { text: template.content },
                    messaging_type: "MESSAGE_TAG",
                    recipient: { id: message.session_id },
                    tag: "CONFIRMED_EVENT_UPDATE" }

      expect(subject.send(:params, ticket)).to include(response)
    end
  end

  describe "completed ticket" do
    let!(:template) { create(:template, :completed) }
    let(:ticket) { build(:ticket, :completed) }

    it "#params" do
      allow(ticket).to receive(:message).and_return(message)
      response = {  message: { text: template.content },
                    messaging_type: "MESSAGE_TAG",
                    recipient: { id: message.session_id },
                    tag: "CONFIRMED_EVENT_UPDATE" }

      expect(subject.send(:params, ticket)).to include(response)
    end
  end
end
