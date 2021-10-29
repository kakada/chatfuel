# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  actived                :boolean
#  avatar                 :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :string
#  mid                    :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  status                 :integer(4)       default("enable")
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer(4)
#  site_id                :bigint(8)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_site_id               (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#
require "rails_helper"
require_relative '../support/shared/omniauth.rb'

RSpec.describe User, type: :model do
  it { is_expected.to define_enum_for(:status).with_values(%i[enable disable]) }
  it { is_expected.to have_many(:identities).dependent(:destroy) }
  it { is_expected.to belong_to(:site).optional }
  it { is_expected.to belong_to(:role).optional }

  describe ".from_omniauth" do
    include_context "shared omniauth"

    context "new user" do
      it "persists new user" do
        expect { User.from_omniauth(auth) }.to change { User.count }.by 1
      end

      context "created" do
        let(:user) { User.from_omniauth(auth) }

        specify { expect(user).not_to be_actived }
        specify { expect(user.role).to be_nil }
      end
    end

    context "existing user" do
      it "does not create duplicate user" do
        expect {
          User.from_omniauth(auth)
          User.from_omniauth(auth)
        }.to change { User.count }.by 1
      end
    end
  end
end
