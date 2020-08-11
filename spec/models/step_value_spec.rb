# == Schema Information
#
# Table name: step_values
#
#  id                :bigint(8)        not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  message_id        :bigint(8)        not null
#  site_id           :bigint(8)
#  variable_id       :bigint(8)        not null
#  variable_value_id :bigint(8)        not null
#
# Indexes
#
#  index_step_values_on_message_id         (message_id)
#  index_step_values_on_site_id            (site_id)
#  index_step_values_on_variable_id        (variable_id)
#  index_step_values_on_variable_value_id  (variable_value_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => messages.id)
#  fk_rails_...  (site_id => sites.id)
#  fk_rails_...  (variable_id => variables.id)
#  fk_rails_...  (variable_value_id => variable_values.id)
#
require 'rails_helper'

RSpec.describe StepValue, type: :model do
  describe '.after_create, set_message_province_id' do
    let(:step_value) { build(:step_value) }

    before {
      step_value.variable_value.raw_value = '01'
      step_value.variable_value.mapping_value = ''
      variable = step_value.variable_value.variable
      variable.is_location = true
      step_value.save
    }

    it { expect(step_value.message.province_id).to eq('01') }
  end

  describe ".most_recent" do
    let(:variable) { build(:variable) }
    let(:first_value) { build(:variable_value, id: 1) }
    let(:last_value) { build(:variable_value, id: 2) }

    before do
      create(:step_value, variable: variable, variable_value: first_value)
      create(:step_value, variable: variable, variable_value: last_value)
    end

    it "return lastest step_value" do
      most_recent = described_class.most_recent

      expect(most_recent.length).to eq 1
      expect(most_recent.first.variable_value).to eq last_value
    end
  end
end
