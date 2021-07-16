# == Schema Information
#
# Table name: pdf_templates
#
#  id          :bigint(8)        not null, primary key
#  content     :text             default("")
#  lang_code   :string           default("en")
#  name        :string           not null
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
  ALLOWED_LANGUAGE_CODES = I18n.available_locales.map(&:to_s)

  belongs_to :schedule

  validates :name, presence: true
  validates :lang_code, inclusion: { in: ALLOWED_LANGUAGE_CODES }

  def name_param
    "#{name}-#{id}".parameterize.underscore
  end
end
