# == Schema Information
#
# Table name: sites
#
#  id           :bigint(8)        not null, primary key
#  code         :string           default("")
#  name         :string           not null
#  tracks_count :integer(4)       default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_sites_on_name  (name)
#
require 'rails_helper'

RSpec.describe Site, type: :model do
  it { should have_attribute(:name) } 
  it { should have_attribute(:code) }
end
