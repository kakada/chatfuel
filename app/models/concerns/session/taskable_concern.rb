module Session::TaskableConcern
  extend ActiveSupport::Concern

  def set_other_gender
    self.gender = 'other'
  end

  def set_00_province
    self.province_id = '00' unless province_id?
  end

  def set_0000_district
    self.district_id = '0000' unless district_id?
  end

  def row_csv
    row = [id, Time.current, platform_name]
    %i(gender province_id district_id).each do |attr|
      row << send("#{attr}_was".to_sym)
      row << send(attr)
    end
    row
  end

  def err_msg
    "Session #{id} cannot be saved due to #{errors.messages}"
  end

  def rollback_to_old_state(row)
    update_columns( gender: row["old_gender"], 
                    province_id: row["old_province_id"],
                    district_id: row["old_district_id"] )
  end
end
