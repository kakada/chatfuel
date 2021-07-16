# == Schema Information
#
# Table name: pdf_templates
#
#  id          :bigint(8)        not null, primary key
#  content     :text             default("")
#  name        :string           default("")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  schedule_id :bigint(8)        not null
#
# Indexes
#
#  index_pdf_templates_on_schedule_id  (schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (schedule_id => schedules.id)
#
class PdfTemplate < ApplicationRecord
  belongs_to :schedule

  # name required
  # when broadcast report through telegram,
  # file name must start with character
  before_save :set_name

  def name_param
    "#{name}-#{id}".parameterize.underscore
  end

  private

  def set_name
    "pdf template for #{schedule.name}"
  end
end
