require 'rails_helper'

RSpec.describe WelcomeHelper, type: :helper do
  describe '#human_size' do
    context "when less than 1k" do
      it 'return plain values' do
        expect(helper.human_size(123)).to eq '123'
      end
    end

    context "when more than 1k" do
      it 'formats number in K' do
        expect(helper.human_size(1234)).to eq '1.23K'
      end
    end

    context "when more than 1M" do
      it 'formats number in M' do
        expect(helper.human_size(1234567)).to eq '1.23M'
      end
    end
  end
end
