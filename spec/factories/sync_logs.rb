# == Schema Information
#
# Table name: sync_logs
#
#  id         :bigint(8)        not null, primary key
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  site_id    :integer(4)
#
FactoryBot.define do
  factory :sync_log do
    
  end
end
