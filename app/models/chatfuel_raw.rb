# == Schema Information
#
# Table name: chatfuel_raws
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ChatfuelRaw < ApplicationRecord
  self.table_name = "chatfuel_raw"
end
