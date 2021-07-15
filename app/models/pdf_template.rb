# == Schema Information
#
# Table name: pdf_templates
#
#  id         :bigint(8)        not null, primary key
#  content    :text             default("")
#  lang_code  :string           default("en")
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PdfTemplate < ApplicationRecord
  ALLOWED_LANGUAGE_CODES = I18n.available_locales.map(&:to_s)

  validates :name, presence: true
  validates :lang_code, inclusion: { in: ALLOWED_LANGUAGE_CODES }

  def name_param
    "#{name}-#{id}".parameterize.underscore
  end
end
