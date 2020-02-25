# == Schema Information
#
# Table name: voice_messages
#
#  id          :bigint(8)        not null, primary key
#  address     :string
#  called_at   :datetime
#  callsid     :integer(4)
#  finished_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :integer(4)
#
RSpec.describe VoiceMessage do
  describe 'associations' do
    it { should have_one(:message).dependent(:destroy) }
    it { should have_many(:steps).through(:message) }
  end

  it '#type' do
    msg = build(:voice_message)

    expect(msg.type).to eq 'IVR'
  end

  it 'alias_attribute' do
    msg = build(:voice_message, callsid: 123)

    expect(msg.session_id).to eq msg.callsid
  end
end
