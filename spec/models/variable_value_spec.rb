# == Schema Information
#
# Table name: variable_values
#
#  id                :bigint(8)        not null, primary key
#  hint              :string(255)      default("")
#  mapping_value_en  :string           default("")
#  mapping_value_km  :string           default("")
#  raw_value         :string           not null
#  status            :string           default("acceptable")
#  step_values_count :integer(4)       default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  variable_id       :bigint(8)        not null
#
# Indexes
#
#  index_variable_values_on_variable_id  (variable_id)
#
# Foreign Keys
#
#  fk_rails_...  (variable_id => variables.id)
#
require 'rails_helper'

RSpec.describe VariableValue, type: :model do
  it { is_expected.to have_attribute(:mapping_value_en) }
  it { is_expected.to have_attribute(:mapping_value_km) }
  it { is_expected.to have_attribute(:hint) }
  it { is_expected.to have_attribute(:raw_value) }
  it { is_expected.to have_attribute(:value_status) }
  it { is_expected.to have_attribute(:step_values_count) }
  it { is_expected.to belong_to(:variable) }

  describe 'before_destroy' do
    let(:step_value)      { create(:step_value) }
    let(:variable_value)  { step_value.variable_value }
    let(:variable_value2) { create(:variable_value) }

    it { expect(variable_value.destroy).to be_falsey }
    it { expect(variable_value2.destroy).to be_truthy }
  end

  describe ".type_of_user_feedback" do
    let!(:feedback1) { create(:variable_value, raw_value: '1', mapping_value_en: 'user feedback', mapping_value_km: 'វាយតម្លៃ') }
    let!(:feedback2) { create(:variable_value, raw_value: 'feedback', mapping_value_en: 'user feedback', mapping_value_km: 'វាយតម្លៃ') }
    let!(:non_feedback) { create(:variable_value, raw_value: 'test', mapping_value_en: 'test', mapping_value_km: 'តេស') }

    it 'returns empty' do
      expect(VariableValue.type_of_user_feedback).to eq []
    end

    it 'returns its type' do
      allow(VariableValue).to receive(:user_feedback).and_return(feedback1)
      expect(VariableValue.type_of_user_feedback).to eq [feedback1, feedback2]
    end
  end
end