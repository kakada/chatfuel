# == Schema Information
#
# Table name: social_providers
#
#  id            :bigint(8)        not null, primary key
#  provider_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class SocialProvider < ApplicationRecord
  SOCIAL_PROVIDERS = %w(facebook twitter linkedin)
  validates :provider_name, presence: true, inclusion: { in: SOCIAL_PROVIDERS }
end
