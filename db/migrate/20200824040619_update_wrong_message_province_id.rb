class UpdateWrongMessageProvinceId < ActiveRecord::Migration[6.0]
  LOCATION_NAMES = { Th: '02', ot: '00', Mo: '02', Kr: '02', Ka: '02', Ba: '02' }
  REVERSE_LOCATION_NAMES = { Kr: '02', ot: '00' }

  def up
    messages.find_each do |m|
      m.update(province_id: LOCATION_NAMES[m.province_id.to_sym])
    end
  end

  def down
    messages.find_each do |m|
      m.update(province_id: REVERSE_LOCATION_NAMES.key(m.province_id).to_s)
    end
  end

  private

  def messages
    @messages ||= Message.where.not(province_id: nil)
  end
end
