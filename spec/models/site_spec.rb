# == Schema Information
#
# Table name: sites
#
#  id           :bigint(8)        not null, primary key
#  code         :string           default("")
#  deleted_at   :datetime
#  lat          :float
#  lng          :float
#  name_en      :string           not null
#  name_km      :string
#  status       :integer(4)       default("disable")
#  sync_status  :integer(4)
#  token        :string           default("")
#  tracks_count :integer(4)       default(0)
#  whitelist    :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  province_id  :string
#
# Indexes
#
#  index_sites_on_deleted_at  (deleted_at)
#  index_sites_on_name_en     (name_en)
#
require "rails_helper"

RSpec.describe Site, type: :model do
  it { is_expected.to have_attribute(:name_en) }
  it { is_expected.to have_attribute(:name_km) }
  it { is_expected.to have_attribute(:code) }
  it { is_expected.to have_attribute(:status) }
  it { is_expected.to have_attribute(:lat) }
  it { is_expected.to have_attribute(:lng) }
  it { is_expected.to have_attribute(:sync_status) }
  it { is_expected.to define_enum_for(:status).with_values(%i[disable enable]) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:tickets) }
  it { is_expected.to have_many(:sync_logs) }
  it { is_expected.to have_many(:site_settings) }
  it { is_expected.to define_enum_for(:sync_status).with_values(%w(failure success)) }

  describe '#before create, generate_token, whitelist, province_id' do
    let(:site) { create(:site, token: nil, code: '0102') }

    it { expect(site.token).not_to be_nil }
    it { expect(site.whitelist).to eq('*') }
    it { expect(site.province_id).to eq('01') }
  end

  describe "validation token and whitelist presence on update" do
    let(:site) { create(:site) }

    it { expect(site.update(token: nil)).to eq(false) }
    it { expect(site.update(whitelist: nil)).to eq(false) }
  end

  describe '#whitelist_format' do
    context 'when *' do
      let(:site) { build(:site, whitelist: '*') }

      it { expect(site.valid?).to eq(true) }
    end

    context 'when an ip address' do
      let(:site) { build(:site, whitelist: '192.168.1.1') }

      it { expect(site.valid?).to eq(true) }
    end

    context 'when more ip addresses' do
      let(:site) { build(:site, whitelist: '192.168.1.1; 192.168.1.2;') }

      it { expect(site.valid?).to eq(true) }
    end

    context 'a wrong ip address' do
      let(:site) { build(:site, whitelist: '192.168.1.299') }

      it { expect(site.valid?).to eq(false) }
    end

    context 'one wrong within ip addresses' do
      let(:site) { build(:site, whitelist: '192.168.1.1; 192.168.1.299') }

      it { expect(site.valid?).to eq(false) }
      it 'has whitelist errors' do
        site.valid?
        expect(site.errors).to include(:whitelist)
      end
    end
  end

  describe '.find_with_whitelist' do
    let!(:site1) { create(:site, whitelist: '*') }
    let!(:site2) { create(:site, whitelist: '192.168.1.1; 192.168.1.2')}

    it { expect(Site.find_with_whitelist(site1.token, '1.1.1.1')).to eq(site1) }
    it { expect(Site.find_with_whitelist(site2.token, '1.1.1.1')).to be_nil }
    it { expect(Site.find_with_whitelist(site2.token, '192.168.1.2')).to eq(site2) }
  end

  describe 'soft delete' do
    let(:site) { create(:site) }

    before {
      site.destroy
    }

    it { expect(Site.find_by(code: site.code)).to be_nil }
    it { expect(Site.with_deleted.find_by(code: site.code)).not_to be_nil }
  end
end
